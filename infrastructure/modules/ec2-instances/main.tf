variable "multiple_instances"{
    type = map(map(map(string)))
}
variable "environment" {}


module "ec2_multiple" {
  source  = "terraform-aws-modules/ec2-instance/aws"

  for_each = var.multiple_instances

  name = "${each.key}"

tags ={
Terraform = "True"
Environment = var.environment

}

}
