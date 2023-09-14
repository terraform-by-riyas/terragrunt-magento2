include {
  path = find_in_parent_folders()
}

terraform {
  source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/ec2-spot-tag"
  
}

dependencies {
  paths = ["../ec2-web-server"]
}

dependency "web-server" {
  config_path = "../ec2-web-server"
}

inputs = {
  resource_id = dependency.web-server.outputs.spot_instance_id
  key = "Name"
  value = "Web Server"
}
