variable "aws_subnet_id" {}
variable "instance_id" {}
variable "name" {}
variable "private_ips" {
    type = list(string)
}
