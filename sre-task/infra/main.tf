# Use Ubuntu 22.04 LTS (amd64) in ap-south-1
data "aws_ami" "ubuntu_2204" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# SSH key for EC2 (from local k3s-key.pub)
resource "aws_key_pair" "k3s" {
  key_name   = "k3s-key-thangaraj"
  public_key = file("${path.module}/k3s-key.pub")
}

# Security group for k3s node
resource "aws_security_group" "k3s_sg" {
  name        = "k3s-sg-thangaraj"
  description = "Security group for k3s single-node cluster"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # NodePort for app 
  ingress {
    from_port   = 30801
    to_port     = 30801
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Kubernetes API 
  ingress {
    from_port   = 6443
    to_port     = 6443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# EC2 instance that will auto-install k3s via user_data
resource "aws_instance" "k3s_node" {
  ami                         = data.aws_ami.ubuntu_2204.id
  instance_type               = "t3.small"
  key_name                    = aws_key_pair.k3s.key_name
  vpc_security_group_ids      = [aws_security_group.k3s_sg.id]
  associate_public_ip_address = true

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "k3s-node"
  }
}
