variable "vpc_id" {
  type=string
  description = "vpc id"
}

variable "internet_gateway_id" {
  type=string
  description = "id of internet gateway"
}
variable "public_subnets" {
  type=list(string)
  description = "list of ids of public subnets to be associated with internet gateway"
}

variable "natgateway_id" {
  type=string
  description = "id of internet gateway"
}
variable "private_subnets" {
  type=list(string)
  description = "list of ids of public subnets to be associated with internet gateway"
}