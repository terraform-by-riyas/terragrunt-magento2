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
  paths = ["../../ec2-servers/ec2-web-server"]
}

dependency "ec2-web-server" {
  config_path = "../../ec2-servers/ec2-web-server"
}

inputs = {
  resource_id = dependency.ec2-web-server.outputs.spot_instance_id
  key = "Name"
  value = "${local.common_vars.environment}-Web Server"
}
