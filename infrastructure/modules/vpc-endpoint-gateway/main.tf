resource "aws_vpc_endpoint" "vpc-s3-endpoint-gw" {
  vpc_id          = var.vpc_id
  service_name    = var.service_name
  route_table_ids = var.route_table_ids

  tags = {
    Name = "my-s3-endpoint"
  }
}