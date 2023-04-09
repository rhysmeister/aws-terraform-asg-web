output "alb_dns_name" {
    value       = aws_lb.web_lb.dns_name
    description = "LB url"
}

output "associate_public_ip_address" {
    description = "Do our instances have a public ip v4 address?"
    value      = aws_launch_configuration.web.associate_public_ip_address
}

output "instance_state_pubip" {
    description = "Instance Public IPs"
    value       = data.aws_instances.web_instances.public_ips
}