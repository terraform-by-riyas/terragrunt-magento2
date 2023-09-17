include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}
terraform {
  source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/aws_network_interface"
}
dependencies {
  paths = ["../../../aws-data", "../../../vpc", "../../../sgs/sg-mariadb", "../../ssh-key","../../ec2-instance-connect"]
}
dependency "vpc" {
  config_path = "../../../vpc"
}

inputs = {
  aws_subnet_id = dependency.vpc.outputs.public_subnets[0]
  private_ips = ["10.0.0.11"]
 name = "eni-Admin-${local.common_vars.project-name}-${local.common_vars.environment}"
 # security_groups = 
 tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
      Project =  "${local.common_vars.project-name}"
      Type = "Magento Web"
    }
}