# AWS INFRASTRUCTURE DEFINITION
# Provisions a Production-Ready Docker Swarm Manager Node

provider "aws" {
  region = "af-south-1" # Cape Town (Low Latency for Kenya)
}

# 1. VPC (The Secure Network)
resource "aws_vpc" "transit_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name        = "transit-core-production"
    Environment = "Production"
  }
}

# 2. Internet Gateway (To allow external traffic)
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.transit_vpc.id
}

# 3. Security Group (The Firewall)
resource "aws_security_group" "swarm_sg" {
  name        = "transit-swarm-sg"
  description = "Allow Web Traffic and Swarm Management"
  vpc_id      = aws_vpc.transit_vpc.id

  # Allow HTTP (Nginx)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTPS (SSL)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow SSH (Restricted to Admin VPN)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["197.0.0.0/8"] # Example: Restricted IP range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 4. EC2 Instance (The Server)
resource "aws_instance" "swarm_manager" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public.id
  security_groups = [aws_security_group.swarm_sg.id]

  # Boot Script: Installs Docker & Starts Swarm automatically
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install docker
              service docker start
              usermod -a -G docker ec2-user
              docker swarm init
              EOF

  tags = {
    Name = "TransitCore-Manager-01"
    Role = "Manager"
  }
}
