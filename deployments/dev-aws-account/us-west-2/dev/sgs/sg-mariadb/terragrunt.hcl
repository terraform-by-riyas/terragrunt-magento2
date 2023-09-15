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

	name        = "MariaDB-Access"
	description = "Security group for Mariadb to access the port 3306 to be accessiblle within the VPC"
	vpc_id      = dependency.vpc.outputs.vpc_id 
	ingress_cidr_blocks      = [dependency.vpc.outputs.vpc_cidr_block]
	ingress_rules            = ["ssh-tcp","mysql-tcp"]
	egress_rules = ["all-all"]

    tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
    }
}
