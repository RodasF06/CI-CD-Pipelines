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
  subnet_id              = aws_subnet.public.id 
  vpc_security_group_ids = [aws_security_group.web_sg.id]

user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y docker
              systemctl start docker
              systemctl enable docker
              
              sleep 20 
              REGION="us-east-1"
              ACCOUNT_ID="945596537419"
              REPO_URL="$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com"

              # Retries para el login
              for i in {1..5}; do
                aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $REPO_URL && break || sleep 10
              done
              
              # Bajar la imagen específica y correrla
              docker pull $REPO_URL/mi-app-repo:latest
              docker run -d -p 80:80 $REPO_URL/mi-app-repo:latest
              EOF

  tags = {
    Name = "WebServer-Docker"
  }
}