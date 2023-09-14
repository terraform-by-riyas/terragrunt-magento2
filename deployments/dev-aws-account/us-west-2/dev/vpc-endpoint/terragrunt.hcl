include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
 source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/vpc-endpoint-gateway"
}

dependencies {
  paths = ["../vpc", "../aws-data"]
}

dependency "vpc" {
  config_path = "../vpc"
}
dependency "aws-data" {
  config_path = "../aws-data"
}
###########################################################
# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.1.2?tab=inputs
###########################################################
inputs = {
  vpc_id             = dependency.vpc.outputs.vpc_id
  // security_group_ids = [dependency.vpc.outputs.default_security_group_id]
  aws_region = "${local.common_vars.aws_region}"
  route_table_ids = dependency.vpc.outputs.private_route_table_ids //Get a list of values
  service_name = "com.amazonaws.${local.common_vars.aws_region}.s3"
  
 
  tags = {
    Terraform   = "true"
    Environment = "${local.common_vars.environment}"
    Project =  "${local.common_vars.project-name}"
  }

}
  