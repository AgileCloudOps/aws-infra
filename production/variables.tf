variable "profile" {
  type    = string
  default = "prod"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.10.0.0/16"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]

}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.10.4.0/24", "10.10.5.0/24", "10.10.6.0/24"]

}

variable "volume_size" {
  type    = number
  default = 50
}

variable "volume_type" {
  type    = string
  default = "gp2"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "ami_name_filter" {
  type    = string
  default = "thabes*"
}

variable "protocol_tcp" {
  type    = string
  default = "tcp"
}

variable "NODE_ENV" {
  type    = string
  default = "dev"
}

variable "PGUSER" {
  type    = string
  default = "csye6225"
}

variable "PGPASSWORD" {
  type    = string
  default = "Thabes-neu1"
}

variable "PGDATABASE" {
  type    = string
  default = "csye6225"
}

variable "PGPORT" {
  type    = number
  default = 5432
}

variable "SERVERPORT" {
  type    = number
  default = 8080
}

variable "DBEngine" {
  type    = string
  default = "postgres"
}

variable "DBInstance" {
  type    = string
  default = "db.t3.micro"
}

variable "StorageRDS" {
  type    = number
  default = 20
}

variable "db_para_group_family" {
  type    = string
  default = "postgres14"
}

variable "db_para_group_name" {
  type    = string
  default = "postgres-thabes"
}

variable "is_rds_publicly_accessible" {
  type    = bool
  default = false
}

variable "is_rds_multi_az" {
  type    = bool
  default = false
}

variable "rds_skip_final_snapshot" {
  type    = bool
  default = true
}

variable "ec2_disable_api_termination" {
  type    = bool
  default = false
}

variable "ami_most_recent" {
  type    = bool
  default = true
}

variable "ec2_associate_public_ip_address" {
  type    = bool
  default = true
}

variable "ec2_delete_on_termination" {
  type    = bool
  default = true
}

variable "s3_force_destroy" {
  type    = bool
  default = true
}

variable "sse_algorithm" {
  type    = string
  default = "AES256"
}
variable "subdomain_name" {
  type    = string
  default = "demo.shivamthabe.me"
}

variable "alias_www" {
  type    = string
  default = "www"
}

variable "ttl" {
  type    = number
  default = 60
}

variable "STATSD_PORT" {
  type    = number
  default = 8125
}

variable "STATSD_HOST" {
  type    = string
  default = "127.0.0.1"
}

variable "PORT80" {
  type    = number
  default = 80
}

variable "PORT443" {
  type    = number
  default = 443
}

variable "HEALTH_CHECK" {
  type    = string
  default = "/healthz"
}

variable "UPTHRESHOLD" {
  type    = string
  default = "5"
}

variable "DOWNTHRESHOLD" {
  type    = string
  default = "3"
}

variable "UPCOMPARISON_OPERATOR" {
  type    = string
  default = "GreaterThanThreshold"
}

variable "DOWNCOMPARISON_OPERATOR" {
  type    = string
  default = "LessThanThreshold"
}
variable "EVAL_PERIOD" {
  type    = string
  default = "2"
}
variable "ALARM_METRIC" {
  type    = string
  default = "CPUUtilization"
}

variable "ALARM_PERIOD" {
  type    = string
  default = "120"
}

variable "ASG_DESIRED_CAPACITY" {
  type    = number
  default = 1
}

variable "ASG_MAX_SIZE" {
  type    = number
  default = 3
}

variable "ASG_MIN_SIZE" {
  type    = number
  default = 1
}
