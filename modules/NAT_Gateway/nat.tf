# Resource block for creating an AWS NAT Gateway
resource "aws_nat_gateway" "natgw" {
  # Use the allocation ID of an Elastic IP for the NAT Gateway
  allocation_id = aws_eip.eip.id
  
  # Specify the subnet where the NAT Gateway should reside
  subnet_id = var.public_subnet
  
  # Add tags to identify the NAT Gateway
  tags = {
    Name = "natgateway"
  }
}
