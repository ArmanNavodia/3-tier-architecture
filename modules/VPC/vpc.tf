# Define a VPC resource named "main" for AWS.
resource "aws_vpc" "main" {
  # Set the CIDR block for the VPC.
  cidr_block = "10.0.0.0/16"
}
