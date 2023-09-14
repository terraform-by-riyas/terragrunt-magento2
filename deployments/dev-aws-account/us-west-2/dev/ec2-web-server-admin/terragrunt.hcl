include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  source  = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git?ref=v5.5.0"
  
}

dependencies {
  paths = ["../aws-data"]
}

dependency "aws-data" {
  config_path = "../aws-data"
}

inputs = {
    name = "admin-webserver"
    ami = dependency.aws-data.outputs.ubuntu_arm_graviton_22_04lts
    instance_type          = "r7g.medium"
    disable_api_termination = false
    create_spot_instance = true
    key_name               = "temp-key"
    monitoring             = false
    vpc_security_group_ids = ["sg-069d560c89e9d9119"]
    tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
      Project =  "${local.common_vars.project-name}"
      Type = "Magento Web Admin"
    }
}
