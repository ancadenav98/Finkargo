output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnets_cidr" {
  value = var.private_subnets_cidr
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}