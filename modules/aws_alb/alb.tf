# Create an Application Load Balancer (ALB)
resource "aws_lb" "alb" {
  name               = var.name                   # Name of the ALB
  load_balancer_type = "application"             # ALB type
  subnets            = var.subnets                # Subnets to attach the ALB to
  security_groups    = var.alb_sg                # Security groups for the ALB
  internal           = var.internal_facing       # Whether the ALB is internal or internet-facing
}

# Create a target group for the ALB
resource "aws_lb_target_group" "alb-tg" {
  name        = "${var.name}-tg"                # Name of the target group
  target_type = "instance"                      # Type of target (instance, ip, or lambda)
  port        = var.port_forward                # Port the target listens on
  protocol    = "HTTP"                          # Protocol used for routing traffic to targets
  vpc_id      = var.vpc_id                      # VPC ID where the targets are located

  # Health check configuration for targets in the target group
  health_check {
    path                = var.path_health_check  # Path to use for health checks
    port                = var.port_forward       # Port the health check listens on
    healthy_threshold   = 2                      # Number of consecutive successful health checks required to consider a target healthy
    unhealthy_threshold = 2                      # Number of consecutive failed health checks required to consider a target unhealthy
    timeout             = 2                      # Amount of time, in seconds, during which no response means a failed health check
    interval            = 10                     # Time interval, in seconds, between health checks
    matcher             = "200"                  # Response status code indicating a healthy target
  }
}

# Attach EC2 instances to the target group
# resource "aws_lb_target_group_attachment" "alb-attachment-tg" {
#   count            = length(var.ec2_instances)                # Number of EC2 instances to attach to the target group
#   target_group_arn = aws_lb_target_group.alb-tg.arn           # ARN of the target group
#   target_id        = var.ec2_instances[count.index]           # ID of the EC2 instance to attach
# }

resource "aws_autoscaling_attachment" "alb-asg-attachement" {
  autoscaling_group_name = var.asg-name
  lb_target_group_arn = aws_lb_target_group.alb-tg.arn
  
}

# Create a listener for the ALB
resource "aws_lb_listener" "lb-listener" {
  load_balancer_arn = aws_lb.alb.arn              # ARN of the ALB
  protocol          = "HTTP"                      # Protocol the listener uses
  port              = var.port_listen             # Port the listener listens on

  # Default action for the listener
  default_action {
    type             = "forward"                  # Type of action (forward, fixed-response)
    target_group_arn = aws_lb_target_group.alb-tg.arn  # ARN of the target group to forward requests to
  }
}
