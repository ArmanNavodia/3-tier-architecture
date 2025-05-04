output "public_subnets_out" {
  value = aws_subnet.subnets_public[*].id
}

output "private_subnets_out" {
  value =aws_subnet.subnets_private[*].id
}