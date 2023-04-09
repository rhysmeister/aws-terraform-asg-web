resource "aws_lb" "web_lb" {
    name               = "web-lb"
    load_balancer_type = "application"
    #subnets            = data.aws_subnets.default.ids
    subnets            = aws_subnet.subnet.*.id
    security_groups    = [aws_security_group.web_lb_sg.id]

    depends_on = [
      aws_subnet.subnet
    ]
}

resource "aws_lb_listener" "web_lb_listener" {
    load_balancer_arn = aws_lb.web_lb.arn
    port              = 80
    protocol          = "HTTP"

    default_action {
      type = "fixed-response"

      fixed_response {
        content_type = "text/plain"
        message_body = "404: page not found"
        status_code  = 404
      }
    }
}

resource "aws_security_group" "web_lb_sg" {
    name   = "web-lb-sg"
    vpc_id = aws_vpc.vpc.id

    # Allow inbound http
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    # Allow all outbound requests
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_lb_target_group" "tg" {
    name     = "web-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id = aws_vpc.vpc.id

    health_check {
        path                = "/"
        protocol            = "HTTP"
        matcher             = "200"
        interval            = 15
        timeout             = 3
        healthy_threshold   = 2
        unhealthy_threshold = 2
    }
}

resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.web_lb_listener.arn
    priority     = 100

    condition {
        path_pattern {
          values = ["*"]
        }
    }

    action {
        type = "forward"
        target_group_arn = aws_lb_target_group.tg.arn
    }
}