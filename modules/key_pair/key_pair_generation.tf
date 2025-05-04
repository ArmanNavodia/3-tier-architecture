// Key-pair Generation (ssh key generation)
resource "aws_key_pair" "terraform-key" {
  key_name   = "terraform-key"
  public_key = file("${path.module}/id_rsa.pub")
}
