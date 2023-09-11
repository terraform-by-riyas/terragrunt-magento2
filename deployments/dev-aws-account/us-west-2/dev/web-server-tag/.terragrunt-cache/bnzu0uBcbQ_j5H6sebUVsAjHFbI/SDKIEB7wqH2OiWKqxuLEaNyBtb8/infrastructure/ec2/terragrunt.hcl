include {
  path = find_in_parent_folders()
}

terraform {
  source  = "${dirname(find_in_parent_folders())}/..//infrastructure/ec2"
  
}

dependencies {
  paths = ["../web-server"]
}

dependency "web-server" {
  config_path = "../web-server"
}

inputs = {
    
  resource_id = dependency.web-server.outputs.spot_instance_id
  key = "Name"
  value = "Spot Instance 1"
}
