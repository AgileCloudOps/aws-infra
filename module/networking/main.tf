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
  most_recent = var.ami_most_recent

  filter {
    name   = "name"
    values = ["${var.ami_name_filter}"]
  }
}

# create an database security group for RDS instance
resource "aws_security_group" "database" {
  name = "database"
  tags = {
    Name = "database"
  }
  vpc_id = aws_vpc.main_vpc.id
  ingress {
    from_port = var.PGPORT
    to_port   = var.PGPORT
    protocol  = var.protocol_tcp
    //cidr_blocks = ["0.0.0.0/0"]
    security_groups = [aws_security_group.application.id]
  }

}

resource "aws_db_parameter_group" "postgres" {
  name   = var.db_para_group_name
  family = var.db_para_group_family
  tags = {
    Name = var.db_para_group_name
  }
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds_subnet_group"
  subnet_ids = [element(aws_subnet.private_subnets[*].id, 1), element(aws_subnet.private_subnets[*].id, 2)]
}

# Create the RDS instance
resource "aws_db_instance" "rds_instance" {
  allocated_storage      = var.StorageRDS
  identifier             = var.PGUSER
  engine                 = var.DBEngine
  instance_class         = var.DBInstance
  db_name                = var.PGDATABASE
  username               = var.PGUSER
  password               = var.PGPASSWORD
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.database.id]
  publicly_accessible    = var.is_rds_publicly_accessible
  parameter_group_name   = aws_db_parameter_group.postgres.name
  multi_az               = var.is_rds_publicly_accessible
  skip_final_snapshot    = var.rds_skip_final_snapshot
}

output "rds_endpoint" {
  value = aws_db_instance.rds_instance.endpoint
}


# launch an EC2 instance in the VPC created by Terraform
resource "aws_instance" "web_server" {
  depends_on = [
    aws_db_instance.rds_instance, aws_s3_bucket.private_bucket
  ]
  ami           = data.aws_ami.latest_ami.id
  instance_type = var.instance_type
  vpc_security_group_ids = [
    aws_security_group.application.id,
  ]
  associate_public_ip_address = var.ec2_associate_public_ip_address
  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = var.ec2_delete_on_termination
  }
  disable_api_termination = var.ec2_disable_api_termination
  iam_instance_profile    = aws_iam_instance_profile.ec2_s3_instance_profile.name

  #count = length(var.public_subnet_cidrs)
  subnet_id = element(aws_subnet.public_subnets[*].id, 1)

  user_data = <<EOF
#!/bin/bash
# Define variables
export NODE_ENV="${var.NODE_ENV}"
export PGUSER="${var.PGUSER}"
export PGHOST="${aws_db_instance.rds_instance.address}" 
export PGPASSWORD="${var.PGPASSWORD}" 
export PGDATABASE="${var.PGDATABASE}"
export PGPORT="${var.PGPORT}"
export SERVERPORT="${var.SERVERPORT}"
export AWS_REGION="${var.region}"
export S3_BUCKETNAME="${aws_s3_bucket.private_bucket.bucket}"

sudo systemctl stop webApp

cd webapp

NODE_ENV=$NODE_ENV PGUSER=$PGUSER PGHOST=$PGHOST PGPASSWORD=$PGPASSWORD PGDATABASE=$PGDATABASE PGPORT=$PGPORT SERVERPORT=$SERVERPORT AWS_REGION=$AWS_REGION S3_BUCKETNAME=$S3_BUCKETNAME npx sequelize-cli db:migrate

cd ..
touch egg
sudo touch nodeEnvVars
sudo chmod 755 nodeEnvVars
echo "NODE_ENV="${var.NODE_ENV}"" >> /home/ec2-user/nodeEnvVars
echo "PGUSER="${var.PGUSER}"" >> /home/ec2-user/nodeEnvVars
echo "PGHOST="${aws_db_instance.rds_instance.address}"" >> /home/ec2-user/nodeEnvVars
echo "PGPASSWORD="${var.PGPASSWORD}"" >> /home/ec2-user/nodeEnvVars
echo "PGDATABASE="${var.PGDATABASE}"" >> /home/ec2-user/nodeEnvVars
echo "PGPORT="${var.PGPORT}"" >> /home/ec2-user/nodeEnvVars
echo "SERVERPORT="${var.SERVERPORT}"" >> /home/ec2-user/nodeEnvVars
echo "AWS_REGION="${var.region}"" >> /home/ec2-user/nodeEnvVars
echo "S3_BUCKETNAME="${aws_s3_bucket.private_bucket.bucket}"" >> /home/ec2-user/nodeEnvVars

sudo systemctl restart webApp


EOF
  tags = {
    Name = "WebApp_EC2_${var.profile}_${formatdate("YYYY-MM-DD-hhmmss", timestamp())}"
  }
}

resource "random_id" "bucket_name" {
  byte_length = 8
}

resource "aws_s3_bucket" "private_bucket" {
  bucket        = "private-${var.profile}-${random_id.bucket_name.hex}"
  force_destroy = var.s3_force_destroy
}

resource "aws_s3_bucket_acl" "private_bucket_acl" {
  bucket = aws_s3_bucket.private_bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "s3_bucket_public_access_blockple" {
  bucket = aws_s3_bucket.private_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.private_bucket.id
  versioning_configuration {
    status = "Disabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_encryption" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.sse_algorithm
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_lifecycle" {

  bucket = aws_s3_bucket.private_bucket.id
  rule {
    id     = "transition_to_standard_ia"
    status = "Enabled"

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    filter {
      prefix = ""
    }
  }
}

resource "aws_iam_policy" "WebAppS3" {
  name        = "WebAppS3"
  description = "Allows EC2 instances to perform S3 buckets"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListMultipartUploadParts",
        "s3:AbortMultipartUpload"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::${aws_s3_bucket.private_bucket.bucket}",
        "arn:aws:s3:::${aws_s3_bucket.private_bucket.bucket}/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "EC2-CSYE6225" {
  name = "EC2-CSYE6225"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "WebAppS3" {
  policy_arn = aws_iam_policy.WebAppS3.arn
  role       = aws_iam_role.EC2-CSYE6225.name
}

resource "aws_iam_instance_profile" "ec2_s3_instance_profile" {
  name = "aws_iam_role.EC2-CSYE6225"
  role = aws_iam_role.EC2-CSYE6225.name
}

data "aws_route53_zone" "webApp_zone" {
  name         = var.subdomain_name
  private_zone = false
}

resource "aws_route53_record" "A_record_webApp" {
  name    = var.subdomain_name
  type    = "A"
  zone_id = data.aws_route53_zone.webApp_zone.zone_id
  ttl     = var.ttl
  records = [aws_instance.web_server.public_ip]
}
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.webApp_zone.zone_id
  name    = var.alias_www
  type    = "A"

  alias {
    name                   = aws_route53_record.A_record_webApp.fqdn
    zone_id                = data.aws_route53_zone.webApp_zone.zone_id
    evaluate_target_health = true
  }
}
