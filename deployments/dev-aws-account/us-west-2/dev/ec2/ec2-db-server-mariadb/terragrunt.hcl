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
  paths = ["../../aws-data", "../../vpc", "../../sgs/sg-mariadb"]
}

dependency "aws-data" {
  config_path = "../../aws-data"
}
dependency "vpc" {
  config_path = "../../vpc"
}

dependency "sg" {
  config_path = "../../sgs/sg-mariadb"
}


inputs = {
    name = "mariadb-server"
    ami = dependency.aws-data.outputs.ubuntu_arm_graviton_22_04lts
    instance_type          = "r7g.medium"
    disable_api_termination = false
    create_spot_instance = true
    spot_wait_for_fulfillment = true
    key_name               = "temp-key"
    monitoring             = false
    vpc_security_group_ids = [dependency.sg.outputs.security_group_id]
    subnet_id = dependency.vpc.outputs.private_subnets[0]
    tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
      Project =  "${local.common_vars.project-name}"
      Type = "DB"
    }
}
