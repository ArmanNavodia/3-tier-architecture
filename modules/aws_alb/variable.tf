variable "subnets"{
    description="provide with subnets"
    type=list(string)
}

variable "vpc_id"{
    type=string
    description="vpc id for alb"
}

variable "alb_sg" {
    description = "specify the required security group for public alb"
  type=set(string)
}
variable "internal_facing" {
    description = "create alb internal facing or external facing"
  type= bool
}

variable "name" {
  type =string
  description = "name of alb"
}
variable "port_forward" {
  type=number
  description = "port range where it will  forward request to"
}
variable "port_listen" {
  type=number
  description = "port range where it will listen to"
}
variable "path_health_check" {
  description = "path for the health checks"
}
variable "asg-name" {
  type = string
  description = "name of the asg for association"
}