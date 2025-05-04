output "instance_lt_out"{
    value = aws_launch_template.instance_lt.id
}

output "name" {
  value = aws_autoscaling_group.ASG_tf.name
}

