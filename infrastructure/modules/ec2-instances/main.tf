locals {
  multiple_instances = {
    one = {
      instance_type     = "t3.micro"
      
      
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp3"
          throughput  = 200
          volume_size = 50
          tags = {
            Name = "my-root-block"
          }
        }
      ]
    }
    two = {
      instance_type     = "t3.small"
     
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp2"
          volume_size = 50
        }
      ]
    }
    three = {
      instance_type     = "t3.medium"
     
    }
  }
}

variable "environment" {}


module "ec2_multiple" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = local.multiple_instances

    name = "${each.key}"
    root_block_device  = lookup(each.value, "root_block_device", [])
tags ={
Terraform = "True"
Environment = var.environment

}

}
