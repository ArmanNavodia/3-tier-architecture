//Elastic Ip
resource "aws_eip" "eip" {
  domain   = "vpc"
}