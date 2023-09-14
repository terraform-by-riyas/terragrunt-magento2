include {
  path = find_in_parent_folders()
}

terraform {
  source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/ec2-spot-tag"
  
}

dependencies {
  paths = ["../ec2-web-server-admin"]
}

dependency "ec2-web-server-admin" {
  config_path = "../ec2-web-server-admin"
}

inputs = {
  resource_id = dependency.ec2-web-server-admin.outputs.spot_instance_id
  key = "Name"
  value = "Web Server Admin"
}
