variable "vpc_id" {}
variable "service_name" {}
variable "route_table_ids" {
    type = list(string)
}
variable "aws_region" {}