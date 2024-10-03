provider "aws" {
  region = var.aws_region
}

# Create a VPC
resource "aws_vpc" "demo_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "example_igw" {
  vpc_id = aws_vpc.demo_vpc.id
  tags = {
    Name = "example-igw"
  }
}

# Create a Route Table for the public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.demo_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example_igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Create Public Subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.public_subnet_1_cidr
  availability_zone = "${var.aws_region}a"
  
  tags = {
    Name = "public-subnet-1"
    "kubernetes.io/role/elb" = "1"    # Tag to make this subnet discoverable as a public subnet
  }
}

# Create Public Subnet 2
resource "aws_subnet" "public_subnet_2" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.public_subnet_2_cidr
  availability_zone = "${var.aws_region}b"
  
  tags = {
    Name = "public-subnet-2"
    "kubernetes.io/role/elb" = "1"    # Tag to make this subnet discoverable as a public subnet
  }
}

# Create Public Subnet 3
resource "aws_subnet" "public_subnet_3" {
  vpc_id            = aws_vpc.demo_vpc.id
  cidr_block        = var.public_subnet_3_cidr
  availability_zone = "${var.aws_region}c"
  
  tags = {
    Name = "public-subnet-3"
    "kubernetes.io/role/elb" = "1"    # Tag to make this subnet discoverable as a public subnet
  }
}

# Associate Public Subnets with Route Table
resource "aws_route_table_association" "public_assoc_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_3" {
  subnet_id      = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_rt.id
}
