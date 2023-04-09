resource "aws_launch_configuration" "web" {
    image_id                    = var.ami
    instance_type               = var.instance_type
    security_groups             = [aws_security_group.web_sg.id]
    associate_public_ip_address = var.public_ipv4
    key_name                    = var.ssh_key_default


    user_data = <<-EOF
                #!/bin/bash
                yum install httpd -y 
                systemctl start httpd
                systemctl enable httpd
                echo "Hello from $(hostname --fqdn)\!" > /var/www/html/index.html
                EOF

    lifecycle {
        create_before_destroy = true
    }
} 