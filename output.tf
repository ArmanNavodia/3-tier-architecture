
output "vpc_id_out" {
  value = module.VPC.vpc_main_out
}

output "subnets_public_id_out" {
  value = module.Subnet.public_subnets_out[*]
}
output "subnets_private_id_out" {
  value = module.Subnet.private_subnets_out[*]
}
output "internet_gateway_id_out" {
  value = module.Internet_Gateway.internet_gateway_out
}

output "private_key"{
  value=module.key_pair.private_key_pem
  sensitive = true
}

output "sg_public_alb_out" {
  value = module.Security_Group.public_alb_sg
}
output "sg_private_alb_out" {
  value = module.Security_Group.private_alb_sg
}
output "sg_public_instance_out" {
  value = module.Security_Group.public_instance_sg
}

output "public_alb_dns_out" {
  value = module.public_alb.load_balancer_out
}
output "private_alb_dns_out" {
  value = module.private_alb.load_balancer_out
}

output "route_table_public_id_out" {
  value = module.route_table.public_routing_table_id_out
}
output "route_table_private_id_out" {
  value = module.route_table.private_routing_table_id_out
}
output "public_route_association_id_out" {
  value = module.route_table.public_routing_table_association_out
}
output "private_route_association_id_out" {
  value = module.route_table.private_routing_table_association_out
}