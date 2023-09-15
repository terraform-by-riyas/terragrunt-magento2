include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}
terraform {
  source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/ec2-spot-tag"
  
}

dependencies {
  paths = ["../bastion"]
}

dependency "bastion" {
  config_path = "../bastion"
}

inputs = {
  resource_id = dependency.bastion.outputs.spot_instance_id
  key = "Name"
  value = "${local.common_vars.environment}-Bastion Server"
}
