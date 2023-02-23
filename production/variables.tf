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

variable "ami_owner_id" {
  type        = string
  description = "AMI owner ID"
  default     = "390646828676"
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
