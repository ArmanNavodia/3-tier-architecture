# Create public subnets
resource "aws_subnet" "subnets_public" {
  count             = length(var.subnets_public)
  vpc_id            = var.vpc_id
  cidr_block        = var.subnets_public[count.index].cidr_block
  availability_zone = var.subnets_public[count.index].az
  
  tags = {
    Name = var.subnets_public[count.index].name
  }
}

# Create private subnets
resource "aws_subnet" "subnets_private" {
  count             = length(var.subnets_private)
  vpc_id            = var.vpc_id
  cidr_block        = var.subnets_private[count.index].cidr_block
  availability_zone = var.subnets_private[count.index].az
  
  tags = {
    Name = var.subnets_private[count.index].name
  }
}
