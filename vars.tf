variable "ami" {
    description = "The ami to use"
    type        = string
    default     = "ami-02241e4f36e06d650"
}

variable "ssh_key_default" {
    description = "Default ssh key"
    type        = string
    default     = "Test"
}

variable "instance_type" {
    description = "Default EC2 instance type"
    type        = string
    default     = "t2.micro"
}

variable "asg_min_size" {
    description = "Minimum number of instance in the ASG"
    type        = number
    default     = 2
}

variable "asg_max_size" {
    description = "Maximum number of instance in the ASG"
    type        = number
    default     = 10
}

variable "public_ipv4" {
    description = "If EC2 instances should have a public IP V4"
    type        = bool 
    default     = true
}

variable "subnet_count" {
    description = "Number of subnets"
    type        = number
    default     = 3
}
