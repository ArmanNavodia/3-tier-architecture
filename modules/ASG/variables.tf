//Variables for the Launch Template
variable "image_name" {
  type    = string
  default = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
}

variable "key_pair_id" {
  type = string
}

  variable "list_subnet" {
    type=list(string)
  }
  variable "set_Security_Group" {
    type=set(string)
  }

  variable "instance_type" {
    type = string
  }

// variables for the ASG
variable "desired_capacity" {
  type = number
  default = 1
}

variable  "max_size" {
    type = number
    default = 2
}

variable "min_size" {
  type = number
  default = 1
}

variable "alb_dns" {
  type = string
}
variable "lb_targetgrp_arn_out" {
  type = string
}

variable "name" {
  type= string
  description = "name of the asg"
}

variable "set_Security_Group_instance" {
  type = set(string)
  description = "security group for the instance created by asg"
}
variable "boolean_public_ip_to_instance" {
  type=bool
  description = "set to true if ec2 needs public ip else set to false"
}
variable "user_data_script" {
  type=string
  description = "pass the script file"
}