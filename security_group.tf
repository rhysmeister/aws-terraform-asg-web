resource "aws_security_group" "web_sg" {
  name = "web-sg"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description      = "Incoming http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.web_lb_sg.id]
  }

  dynamic "ingress" {
    for_each = var.public_ipv4 ? [1] : []
    content {
      description = "Allow incoming ssh when instance has a public ip"
      from_port = 22
      to_port   = 22
      protocol  = "tcp"
      cidr_blocks = ["${chomp(data.http.myip.response_body)}/32"]
    }
  }

  # Allow all outbound requests
  egress {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

}