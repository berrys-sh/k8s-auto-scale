####################################################################
#
# Variables used. All have defaults
#
####################################################################

# KK Playground. Cluster must be called 'demo-eks'
variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
  default     = "demo-eks"
}

# KK Playground. Cluster role must be called 'eksClusterRole'
variable "cluster_role_name" {
  type        = string
  description = "Name of the cluster role"
  default     = "eksClusterRole"
}

# KK Playground. Node role must be called 'eks-demo-node'
variable "node_role_name" {
  type        = string
  description = "Name of node role"
  default     = "eks-demo-node"
}

variable "node_group_desired_capacity" {
  type        = number
  description = "Desired capacity of Node Group ASG."
  default     = 3
}
variable "node_group_max_size" {
  type        = number
  description = "Maximum size of Node Group ASG. Set to at least 1 greater than node_group_desired_capacity."
  default     = 4
}

variable "node_group_min_size" {
  type        = number
  description = "Minimum size of Node Group ASG."
  default     = 1
}

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

variable "ecr_repository_name" {
  description = "Name of the ECR repository"
  type        = string
  default     = "demo-eks-repo"
}
variable "node_group_desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}
variable "eks_cluster_role_name" {
  description = "Name of the EKS Cluster IAM Role"
  type        = string
  default     = "eksClusterRole"
}