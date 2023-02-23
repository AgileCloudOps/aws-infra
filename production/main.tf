data "aws_availability_zones" "available" {

}

module "mynetwork" {
  source               = "../module/networking"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = data.aws_availability_zones.available.names
  profile              = var.profile
  ami_owner_id         = var.ami_owner_id
  volume_size          = var.volume_size
  volume_type          = var.volume_type
  instance_type        = var.instance_type
  ami_name_filter      = var.ami_name_filter
  protocol_tcp         = var.protocol_tcp
}

