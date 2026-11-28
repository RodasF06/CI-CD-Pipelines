resource "aws_security_group" "web_sg" {
  name        = "web-sg-cicd-private"
  description = "Security group para instancia en subred privada"
  vpc_id      = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "web-sg-cicd-private" }
}

resource "aws_security_group" "vpc_endpoints" {
  name        = "vpc-endpoints-sg"
  description = "Permite HTTPS desde la EC2 hacia los VPC Endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "HTTPS desde la EC2"
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "vpc-endpoints-sg"
  }
}

resource "aws_iam_role" "ec2_ecr_role" {
  name = "ec2_ecr_readonly_role_v2"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_read" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2_ecr_profile_v2"
  role = aws_iam_role.ec2_ecr_role.name
}

resource "aws_iam_policy" "ssm_params_read_policy" {
  name        = "ec2-ssm-params-read-policy"
  description = "Permite a la EC2 leer únicamente los parámetros de su proyecto en SSM"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ]
        Resource = "arn:aws:ssm:${var.region}:*:parameter/cicd-project/dev/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_params_attach" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = aws_iam_policy.ssm_params_read_policy.arn
}

resource "aws_iam_policy" "cloudwatch_logs_policy" {
  name        = "ec2-cloudwatch-logs-policy"
  description = "Permite a la EC2 enviar logs y métricas a CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ]
        Resource = "${aws_cloudwatch_log_group.app_logs.arn}:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_attach" {
  role       = aws_iam_role.ec2_ecr_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs_policy.arn
}