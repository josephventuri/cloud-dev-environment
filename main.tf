# ------------------------------------------------------------------------------
# VPC: Creates a Virtual Private Cloud with DNS support
# ------------------------------------------------------------------------------
resource "aws_vpc" "mtc_vpc" {
  cidr_block           = "10.123.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev"
  }
}

# ------------------------------------------------------------------------------
# Subnet: Public subnet inside the VPC with automatic public IP assignment
# ------------------------------------------------------------------------------
resource "aws_subnet" "mtc_public_subnet" {
  vpc_id                  = aws_vpc.mtc_vpc.id
  cidr_block              = "10.123.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-west-1a"

  tags = {
    Name = "dev-public"
  }
}

# ------------------------------------------------------------------------------
# Internet Gateway: Enables internet access for the VPC
# ------------------------------------------------------------------------------
resource "aws_internet_gateway" "mtc_internet_gateway" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

# ------------------------------------------------------------------------------
# Route Table: Defines route to internet through the Internet Gateway
# ------------------------------------------------------------------------------
resource "aws_route_table" "mtc_public_rt" {
  vpc_id = aws_vpc.mtc_vpc.id

  tags = {
    Name = "dev_public_rt"
  }
}

# Default route to the Internet for outbound traffic
resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.mtc_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.mtc_internet_gateway.id
}

# Associates the public subnet with the route table
resource "aws_route_table_association" "mtc_public_assoc" {
  subnet_id      = aws_subnet.mtc_public_subnet.id
  route_table_id = aws_route_table.mtc_public_rt.id
}

# ------------------------------------------------------------------------------
# Security Group: Allows all inbound and outbound traffic (for development use)
# ------------------------------------------------------------------------------
resource "aws_security_group" "mtc_sg" {
  name        = "dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.mtc_vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ------------------------------------------------------------------------------
# SSH Key Pair: Uses a local public key for EC2 SSH access
# ------------------------------------------------------------------------------
resource "aws_key_pair" "mtc_auth" {
  key_name   = "mtckey"
  public_key = file("~/.ssh/mtckey.pub")
}

# ------------------------------------------------------------------------------
# EC2 Instance: Launches a dev node with Docker and SSH access
# ------------------------------------------------------------------------------
resource "aws_instance" "dev_node" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.server_ami.id
  key_name               = aws_key_pair.mtc_auth.key_name
  vpc_security_group_ids = [aws_security_group.mtc_sg.id]
  subnet_id              = aws_subnet.mtc_public_subnet.id
  user_data              = file("userdata.tpl")  # Bootstraps Docker install

  root_block_device {
    volume_size = 10
  }

  tags = {
    Name = "dev-node"
  }

  # ----------------------------------------------------------------------------
  # Local Provisioner: Adds SSH config entry to local machine for quick access
  # ----------------------------------------------------------------------------
  provisioner "local-exec" {
    command = templatefile("${path.module}/linux-ssh-config.tpl", {
      hostname     = self.public_ip,
      user         = "ubuntu",
      identityfile = "~/.ssh/mtckey"
    })
    interpreter = var.host_os == "windows" ? ["Powershell", "-Command"] : ["bash", "-c"]
  }
}
