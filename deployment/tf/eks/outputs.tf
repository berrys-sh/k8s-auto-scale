output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.demo_vpc.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value = [
    aws_subnet.public_subnet_1.id,
    aws_subnet.public_subnet_2.id,
    aws_subnet.public_subnet_3.id
  ]
}
