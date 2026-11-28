resource "aws_ecr_repository" "app_repo" {
  name                 = "mi-app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = "Dev"
    Project     = "CI-CD-Pipeline"
  }
}

resource "aws_instance" "web_app" {
  ami                    = "ami-0440d3b780d96b29d"
  instance_type          = "t2.micro"
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker aws-cli
              systemctl start docker
              systemctl enable docker
              
              sleep 20 
              REGION="${var.region}"
              ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
              REPO_URL="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"
              LOG_GROUP_NAME="/aws/ec2/cicd-project-app"

              # Obtener configuración y secretos desde SSM Parameter Store
              APP_ENV=$(aws ssm get-parameter --name "/cicd-project/dev/APP_ENV" --region $REGION --query "Parameter.Value" --output text)
              APP_SECRET=$(aws ssm get-parameter --name "/cicd-project/dev/APP_SECRET_KEY" --with-decryption --region $REGION --query "Parameter.Value" --output text)

              # Retries para el login en ECR
              for i in {1..5}; do
                aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REPO_URL && break || sleep 10
              done
              
              # Bajar la imagen del contenedor
              docker pull $REPO_URL/mi-app-repo:latest

              # Ejecutar el contenedor configurando el driver de logs nativo hacia CloudWatch
              docker run -d -p 80:80 \
                -e APP_ENV="$APP_ENV" \
                -e APP_SECRET_KEY="$APP_SECRET" \
                --name web-app-container \
                --log-driver=awslogs \
                --log-opt awslogs-region="$REGION" \
                --log-opt awslogs-group="$LOG_GROUP_NAME" \
                --log-opt awslogs-stream="web-container-instance" \
                $REPO_URL/mi-app-repo:latest
              EOF

  tags = {
    Name = "WebServer-Docker-Private"
  }
}