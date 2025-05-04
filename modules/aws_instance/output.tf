output "ec2_public_out" {
  value = aws_instance.frontend[*].id
}
output "ec2_private_out" {
  value = aws_instance.backend[*].id
}

output "ec2_public_ip_out"{
  value = aws_instance.frontend[*].public_ip
}

output "ec2_private_ip_out"{
  value = aws_instance.backend[*].private_ip
}