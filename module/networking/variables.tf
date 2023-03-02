variable "profile" {
  type    = string
  default = "dev"
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

variable "availability_zones" {
  type        = list(string)
  description = "Availability Zones"
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

variable "region" {
  type    = string
  default = "us-east-1"
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
//
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
