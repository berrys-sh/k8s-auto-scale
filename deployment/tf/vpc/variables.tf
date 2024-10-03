variable "aws_region" {
  description = "AWS region where VPC will be created"
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "The name of the VPC"
  default     = "demo-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_1_cidr" {
  description = "The CIDR block for the first public subnet"
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "The CIDR block for the second public subnet"
  default     = "10.0.2.0/24"
}

variable "public_subnet_3_cidr" {
  description = "The CIDR block for the third public subnet"
  default     = "10.0.3.0/24"
}
