
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
