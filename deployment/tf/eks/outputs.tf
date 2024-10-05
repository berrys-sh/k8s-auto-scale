output "vpc_id" {
  description = "The ID of the VPC"
  value       = data.aws_vpc.demo_vpc.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}
