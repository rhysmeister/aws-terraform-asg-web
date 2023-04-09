resource "aws_subnet" "subnet" {
    #for_each = toset(data.aws_availability_zones.available_azs.names)  # Causes issues looking up the subnets elsewhere
    count = var.subnet_count
    vpc_id = aws_vpc.vpc.id
    availability_zone = data.aws_availability_zones.available_azs.names[count.index]
    cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index + 1)
    assign_ipv6_address_on_creation = false

    tags = {
        Name = "test-subnet-${count.index}"
    }
}