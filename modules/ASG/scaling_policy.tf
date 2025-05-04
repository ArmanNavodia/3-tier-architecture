resource "aws_autoscaling_policy" "asg_policy_up" {
  name="${var.name}_policy_up"
  scaling_adjustment = 1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.ASG_tf.name
}

resource "aws_cloudwatch_metric_alarm" "asg_cpu_alarm_up" {
  alarm_name = "${var.name}_alarm_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "90"
  dimensions = {
    autoscaling_group_name="${aws_autoscaling_group.ASG_tf.name}"
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions = [aws_autoscaling_policy.asg_policy_up.arn]
}

resource "aws_autoscaling_policy" "asg_policy_down" {
  name="${var.name}_policy_down"
  scaling_adjustment = -1
  adjustment_type = "ChangeInCapacity"
  cooldown = 300
  autoscaling_group_name = aws_autoscaling_group.ASG_tf.name
}

resource "aws_cloudwatch_metric_alarm" "asg_cpu_alarm_down" {
  alarm_name = "${var.name}_alarm_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = "60"
  statistic = "Average"
  threshold = "30"
  dimensions = {
    AutoScalingGroupName="${aws_autoscaling_group.ASG_tf.name}"
  }
  alarm_description = "This metric monitors ec2 cpu utilization"
  alarm_actions = [aws_autoscaling_policy.asg_policy_down.arn]
}