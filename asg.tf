resource "aws_autoscaling_group" "asg" {
    name                 = "web-asg"
    launch_configuration = aws_launch_configuration.web.name
    vpc_zone_identifier  = aws_subnet.subnet.*.id
    target_group_arns    = [aws_lb_target_group.tg.arn]
    health_check_type    = "ELB"

    min_size = var.asg_min_size
    max_size = var.asg_max_size

    tag {
        key                 = "Name"
        value               = "aws-web"
        propagate_at_launch = true
    }
}