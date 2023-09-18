resource "aws_network_interface" "this" {
  subnet_id       = var.aws_subnet_id
  private_ips     = var.private_ips
  description = var.description
  
  attachment {
    instance     = var.instance_id
    device_index = 1
  }
  tags = {
    Name = var.name
  }
  }
