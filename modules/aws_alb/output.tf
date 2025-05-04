output "load_balancer_out" {
  description = "Outputs the value of the load balancer dns"
  value       = aws_lb.alb.dns_name
}

output "lb_targetgrp_arn_out"{
  value = aws_lb_target_group.alb-tg.arn
}