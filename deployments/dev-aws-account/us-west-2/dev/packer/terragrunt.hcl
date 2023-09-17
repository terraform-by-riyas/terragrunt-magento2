include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/packer"
}
###########################################################
#https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest?tab=inputs
###########################################################

inputs = {

    tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
    }
}
