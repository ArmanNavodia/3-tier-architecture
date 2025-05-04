# Data source to retrieve the latest Ubuntu AMI meeting specific criteria
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Owner ID for Canonical
  filter {
    name   = "name"
    values = ["${var.image_name}"]  # Filtering by image name provided as a variable
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]  # Filter for EBS root device type
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]  # Filter for HVM virtualization type
  }
}

resource "aws_launch_template" "instance_lt" {
  name_prefix       = "${var.name}_lt"
  image_id          = data.aws_ami.ubuntu.id
  instance_type     = var.instance_type
  key_name          = var.key_pair_id
  disable_api_termination = false
  # vpc_security_group_ids = var.set_Security_Group
  

  network_interfaces {
    associate_public_ip_address = var.boolean_public_ip_to_instance
    security_groups = var.set_Security_Group_instance
    # vpc_security_group_ids=var.set_Security_Group_instance
    # subnet_id                   = var.list_subnet[count.index]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-instance"
    }
  }

  # metadata_options {
  #   http_tokens = "required"
  #   http_put_response_hop_limit = 2
  #   http_endpoint               = "enabled"
  # }

  # credit_specification {
  #   cpu_credits = "standard"
  # }

  # instance_market_options {
  #   market_type = "spot"
  #   spot_options {
  #     spot_instance_type       = "persistent"
  #     block_duration_minutes   = 120
  #     instance_interruption_behavior = "terminate"
  #   }
  # }

  # placement {
  #   tenancy = "default"
  # }

  monitoring {
    enabled = true
  }

  # capacity_reservation_specification {
  #   capacity_reservation_preference = "open"
  # }

  # instance_initiated_shutdown_behavior = "terminate"

  # user_data = filebase64("${path.module}/installClient.sh")
  user_data = var.user_data_script
}


// Launch template for the private instances
# resource "aws_launch_template" "private_instance_lt" {
#   name_prefix       = "private_instance_lt"
#   image_id          = data.aws_ami.ubuntu.id
#   instance_type     = "t2.medium"
#   key_name          = var.key_pair_id
#   disable_api_termination = false
#   vpc_security_group_ids = var.set_Security_Group

#   network_interfaces {
#     # associate_public_ip_address = true
#     subnet_id                   = var.list_private_subnet[count.index]
#   }

#   tag_specifications {
#     resource_type = "instance"
#     tags = {
#       Name = "backend-instance"
#     }
#   }

#   metadata_options {
#     http_tokens = "required"
#     http_put_response_hop_limit = 2
#     http_endpoint               = "enabled"
#   }

#   credit_specification {
#     cpu_credits = "standard"
#   }

#   instance_market_options {
#     market_type = "spot"
#     spot_options {
#       spot_instance_type       = "persistent"
#       block_duration_minutes   = 120
#       instance_interruption_behavior = "terminate"
#     }
#   }

#   placement {
#     tenancy = "default"
#   }

#   monitoring {
#     enabled = true
#   }

#   capacity_reservation_specification {
#     capacity_reservation_preference = "open"
#   }

#   instance_initiated_shutdown_behavior = "terminate"

#   user_data = filebase64("${path.module}/installServer.sh")
# }