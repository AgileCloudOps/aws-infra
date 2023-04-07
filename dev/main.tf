data "aws_availability_zones" "available" {

}

module "mynetwork" {
  source                          = "../module/networking"
  vpc_cidr                        = var.vpc_cidr
  public_subnet_cidrs             = var.public_subnet_cidrs
  private_subnet_cidrs            = var.private_subnet_cidrs
  availability_zones              = data.aws_availability_zones.available.names
  profile                         = var.profile
  volume_size                     = var.volume_size
  volume_type                     = var.volume_type
  instance_type                   = var.instance_type
  ami_name_filter                 = var.ami_name_filter
  protocol_tcp                    = var.protocol_tcp
  region                          = var.region
  NODE_ENV                        = var.NODE_ENV
  PGUSER                          = var.PGUSER
  PGPASSWORD                      = var.PGPASSWORD
  PGDATABASE                      = var.PGDATABASE
  PGPORT                          = var.PGPORT
  SERVERPORT                      = var.SERVERPORT
  DBEngine                        = var.DBEngine
  DBInstance                      = var.DBInstance
  StorageRDS                      = var.StorageRDS
  is_rds_publicly_accessible      = var.is_rds_publicly_accessible
  is_rds_multi_az                 = var.is_rds_multi_az
  rds_skip_final_snapshot         = var.rds_skip_final_snapshot
  ec2_disable_api_termination     = var.ec2_disable_api_termination
  ami_most_recent                 = var.ami_most_recent
  ec2_associate_public_ip_address = var.ec2_associate_public_ip_address
  ec2_delete_on_termination       = var.ec2_delete_on_termination
  s3_force_destroy                = var.s3_force_destroy
  sse_algorithm                   = var.sse_algorithm
  subdomain_name                  = var.subdomain_name
  ttl                             = var.ttl
  alias_www                       = var.alias_www
  STATSD_PORT                     = var.STATSD_PORT
  STATSD_HOST                     = var.STATSD_HOST
  HEALTH_CHECK                    = var.HEALTH_CHECK
  UPTHRESHOLD                     = var.UPTHRESHOLD
  DOWNTHRESHOLD                   = var.DOWNTHRESHOLD
  UPCOMPARISON_OPERATOR           = var.UPCOMPARISON_OPERATOR
  DOWNCOMPARISON_OPERATOR         = var.DOWNCOMPARISON_OPERATOR
  EVAL_PERIOD                     = var.EVAL_PERIOD
  ALARM_METRIC                    = var.ALARM_METRIC
  ALARM_PERIOD                    = var.ALARM_PERIOD
  ASG_DESIRED_CAPACITY            = var.ASG_DESIRED_CAPACITY
  ASG_MAX_SIZE                    = var.ASG_MAX_SIZE
  ASG_MIN_SIZE                    = var.ASG_MIN_SIZE
}

