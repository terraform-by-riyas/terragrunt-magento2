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
  aws_subnet_id = dependency.vpc.outputs.private_subnets[0]
  private_ips = ["10.0.10.10"]
 # security_groups = 
 tags = {
      Name = "DB"
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
      Project =  "${local.common_vars.project-name}"
      Type = "Magento Web"
    }
}
