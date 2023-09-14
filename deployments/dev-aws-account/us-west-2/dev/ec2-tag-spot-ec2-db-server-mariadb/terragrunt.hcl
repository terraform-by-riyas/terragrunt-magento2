include {
  path = find_in_parent_folders()
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
  value = "Magento DB MariaDB Server"
}
