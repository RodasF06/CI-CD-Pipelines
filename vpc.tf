resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  tags = { Name = "vpc-cicd-project" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Subnet publica 

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {Name = "subnet-public-us-east-1"}
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {Name = "rt-public"}
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# Subnet privada (EC2)

resource "aws_subnet" "private" {
 vpc_id = aws_vpc.main.id
 cidr_block = "10.0.2.0/24"
 availability_zone = "us-east-1"
 tags = {Name = "subnet-private-us-east-1"}
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  tags = {Name = "rt-private"}
}

resource "aws_route_table_association" "private_assoc"{
  subnet_id = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}

# VPC Endpoint Gateway 

resource "aws_vpc_endpoint" "s3" {
  vpc_id = aws_vpc.main.id
  service_name = "com.amazonaws.us-east-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids = [aws_route_table.private_rt]
  tags = {Name = "s3-gateway-endpoint"}
}