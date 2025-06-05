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
  

  network_interfaces {
    associate_public_ip_address = var.boolean_public_ip_to_instance
    security_groups = var.set_Security_Group_instance
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.name}-instance"
    }
  }

  monitoring {
    enabled = true
  }

  user_data = var.user_data_script
}
