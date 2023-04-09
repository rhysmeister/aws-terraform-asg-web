data "aws_availability_zones" "available_azs" {
  state = "available"
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

# This is only here for testing purposes and should not be treated as gospel
# Pay attention to the note: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/instances
data "aws_instances" "web_instances" {
  instance_tags = {
    Name = "aws-web"
  }
}
