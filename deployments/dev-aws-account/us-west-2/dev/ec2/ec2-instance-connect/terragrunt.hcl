include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}
terraform {
  source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/ec2-instance-connect"
  
}

inputs = {
  ssm-role-name = "${local.common_vars.environment}-ssm-role"
  key = "Name"
  value = "${local.common_vars.environment}-Instance Connect Role"
  key = "Terraform"
  value = "yes"
}
