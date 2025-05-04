//Web Roles
variable "min_size_webrole" {
  description = "Minimum size for autoscaling group of Webrole"
}

variable "max_size_webrole" {
  description = "Maximum size for autoscaling group of Webrole"
}

variable "desired_capacity_webrole" {
  description = "Desired capacity for autoscaling group of Webrole"
}

//BG Roles

variable "min_size_bgrole" {
  description = "Minimum size for autoscaling group of bgrole"
}

variable "max_size_bgrole" {
  description = "Maximum size for autoscaling group of bgrole"
}

variable "desired_capacity_bgrole" {
  description = "Desired capacity for autoscaling group of bgrole"
}

variable "frontend_inst_type" {
  type = string
}

variable "backend_inst_type" {
  type = string
}