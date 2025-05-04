output "public_routing_table_id_out" {
  value = aws_route_table.public_route_table.id
}

output "private_routing_table_id_out" {
  value = aws_route_table.private_route_table.id
}

output "public_routing_table_association_out" {
  value =aws_route_table_association.public_subnets_association[*].id
  }

  output "private_routing_table_association_out" {
  value =aws_route_table_association.private_subnets_association[*].id
  }