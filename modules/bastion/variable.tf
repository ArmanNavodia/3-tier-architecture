variable "image_name" {
  description = "name of the ami"
  default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}
variable "key_pair_id" {
  description = "id of key pair"
  type = string
}

variable "public_subnet" {
  description = "id of the public subnet where this bastion will be created"
  type = string
}

variable "set_Security_Group_public" {
  description = "id of public security group"
  type = set(string)
}