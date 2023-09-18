include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/ec2-instances" 
#  source  = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git?ref=v5.5.0" 
}

dependencies {
  paths = ["../../../aws-data", "../../../vpc", "../../../sgs/sg-mariadb", "../../ssh-key","../../ec2-instance-connect"]
}

dependency "aws-data" {
  config_path = "../../../aws-data"
}
dependency "vpc" {
  config_path = "../../../vpc"
}

dependency "sg-db" {
  config_path = "../../../sgs/sg-mariadb"
}
dependency "ssh-key" {
  config_path = "../../ssh-key"
}
dependency "ec2-instance-connect" {
  config_path = "../../ec2-instance-connect"
}

inputs = {


environment = "dev"
}

