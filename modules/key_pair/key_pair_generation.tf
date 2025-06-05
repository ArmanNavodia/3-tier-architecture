// Key-pair Generation (ssh key generation)

resource "tls_private_key" "id_rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "terraform-key" {
  key_name   = "terraform-key"
  public_key = tls_private_key.id_rsa.public_key_openssh
}
