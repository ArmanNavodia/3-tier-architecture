output "public_instance_sg" {
  value = aws_security_group.public_instance_sg.id
}

output "private_instance_sg" {
  value = aws_security_group.private_instance_sg.id
}

output "database_sg"{
  value = aws_security_group.database_sg.id
}

output "public_alb_sg" {
  value = aws_security_group.public_alb_security_group.id
}
output "private_alb_sg" {
  value = aws_security_group.private_ALB_sg.id
}

