variable "image_name" {
  type    = string
  default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}
  variable "list_public_subnet" {
    type=list(string)
  }
  variable "set_Security_Group_public" {
    type=set(string)
  }
    variable "list_private_subnet" {
    type=list(string)
  }
  variable "set_Security_Group_private" {
    type=set(string)
  }
variable "key_pair_id" {
  type = string
}

variable pvtalb_dns_name{
  type = string
}

# variable application_server{
#   type = string
# }

variable database_server{
  type = string
}

// Later update this db_instance_public_ip into db_instance_private_ip
# variable "db_instance_public_ip" {
#   type = string
# }
variable "db_instance_private_ip" {
  type = string
}