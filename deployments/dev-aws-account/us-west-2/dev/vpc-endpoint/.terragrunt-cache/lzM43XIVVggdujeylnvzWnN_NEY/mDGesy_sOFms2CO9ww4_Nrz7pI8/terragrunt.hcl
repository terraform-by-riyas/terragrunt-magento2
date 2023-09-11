include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  source  = "https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/modules/vpc-endpoints"
  
}

dependencies {
  paths = ["../vpc"]
}

dependency "vpc" {
  config_path = "../vpc"
}
###########################################################
# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.1.2?tab=inputs
###########################################################
inputs = {
  vpc_id             = dependency.vpc.outputs.vpc_id
  security_group_ids = dependency.vpc.outputs.default_security_group_id
  service = "s3"
  tags                = { Name = "${local.common_vars.project-name}-${local.common_vars.environment}-s3-vpc-endpoint" }
}
  