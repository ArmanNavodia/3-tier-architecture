# Define an AWS Internet Gateway resource named "gw" associated with a specified VPC.

resource "aws_internet_gateway" "gw" {
  # Associate the Internet Gateway with the specified VPC.
  vpc_id = var.vpc_id

  # Add tags to the Internet Gateway for better organization and identification.
  tags = {
    Name = "internet-gateway"
  }
}
