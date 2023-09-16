include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  source  = "github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=v5.1.0"  
}

dependencies {
  paths = ["../../vpc"]
}

dependency "vpc" {
  config_path = "../../vpc"
}
###########################################################
#https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest?tab=inputs
###########################################################

inputs = {

	name        = "${local.common_vars.environment}-${local.common_vars.project-name}-varnish-server"
	vpc_id      = dependency.vpc.outputs.vpc_id 
	ingress_cidr_blocks      = [dependency.vpc.outputs.vpc_cidr_block]
  ingress_rules            = ["http-80-tcp"]
# Open for self (rule or from_port+to_port+protocol+description)
  computed_ingress_with_self = [
    {
      from_port   = 8080  
      to_port     = 8080
      protocol    = 6
      description = "Varnish-${dependency.vpc.outputs.name}"
      self        = true
    },
  
  ]
  number_of_computed_ingress_with_self = 1

egress_rules = ["all-all"]
    tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
    }
}
