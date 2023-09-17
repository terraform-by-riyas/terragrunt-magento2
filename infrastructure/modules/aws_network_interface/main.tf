resource "aws_network_interface" "this" {
  subnet_id       = var.aws_subnet_id
  private_ips     = var.private_ips
  tags = {
    Name = "DB"
  }
  }