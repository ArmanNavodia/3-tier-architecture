output "nat_gw_out" {
  value = aws_nat_gateway.natgw.id
}

output "elatic_ip_out" {
  value = aws_eip.eip.public_ip
}