# Create Auto Scaling Group for frontend
resource "aws_autoscaling_group" "ASG_tf" {
  name                 = var.name
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  min_size             = var.min_size
  force_delete         = true
  depends_on           = [var.alb_dns,aws_launch_template.instance_lt]
  target_group_arns    = [var.lb_targetgrp_arn_out]
  health_check_type    = "ELB"
  vpc_zone_identifier  = var.list_subnet
  launch_template {
    id=aws_launch_template.instance_lt.id
    version = aws_launch_template.instance_lt.latest_version
  }
  tag {
    key                 = "Name"
    value               = var.name
    propagate_at_launch = true
  }
  
}



