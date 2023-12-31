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
  paths = ["../ec2-db-server-mariadb"]
}

dependency "ec2-db-server-mariadb" {
  config_path = "../ec2-db-server-mariadb"
}

inputs = {
  resource_id = dependency.ec2-db-server-mariadb.outputs.spot_instance_id
  key = "Name"
  value = "${local.common_vars.environment}-Magento DB MariaDB Server"
}
