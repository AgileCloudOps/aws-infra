resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "main_vpc_${var.profile}"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "Public Subnet_${var.profile}${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "Private Subnet_${var.profile}${count.index + 1}"
  }
}

resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main_vpc_internet_gateway_${var.profile}"
  }
}

resource "aws_route_table" "public_route_Table" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }
  tags = {
    Name = "Public_Route_Table_${var.profile}"
  }
}

resource "aws_route_table" "private_route_Table" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "Private_Route_Table_${var.profile}"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_route_Table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = aws_route_table.private_route_Table.id
}

# create an EC2 security group for web applications
resource "aws_security_group" "application" {
  name = "application"
  tags = {
    Name = "application"
  }
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = var.protocol_tcp
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = var.protocol_tcp
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = var.protocol_tcp
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = var.protocol_tcp
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "latest_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["${var.ami_name_filter}"]
  }

  owners = ["${var.ami_owner_id}"]
}

# launch an EC2 instance in the VPC created by Terraform
resource "aws_instance" "web_server" {
  ami           = data.aws_ami.latest_ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.application.id,
  ]
  associate_public_ip_address = true
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = true
  }
  disable_api_termination = false

  #count = length(var.public_subnet_cidrs)
  subnet_id = element(aws_subnet.public_subnets[*].id, 1)

  tags = {
    Name = "WebApp_EC2_${var.profile}_${formatdate("YYYY-MM-DD-hhmmss", timestamp())}"
  }
}
