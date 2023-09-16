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
  paths = ["../../../aws-data", "../../../vpc", "../../../sgs/sg-varnish", "../../ssh-key","../../ec2-instance-connect"]
}
dependency "aws-data" {
  config_path = "../../../aws-data"
}
dependency "vpc" {
  config_path = "../../../vpc"
}

dependency "sg-varnish" {
  config_path = "../../../sgs/sg-varnish"
}
dependency "ssh-key" {
  config_path = "../../ssh-key"
}
dependency "ec2-instance-connect" {
  config_path = "../../ec2-instance-connect"
}

inputs = {
    name = "${local.common_vars.project-name}-varnish"
    ami = dependency.aws-data.outputs.ubuntu_arm_graviton_22_04lts
    instance_type          = "r7g.medium"
    disable_api_termination = false
    create_spot_instance = true
    spot_wait_for_fulfillment = true
    key_name               = dependency.ssh-key.outputs.key-name
    monitoring             = false
    vpc_security_group_ids = [dependency.sg-varnish.outputs.security_group_id] // http and https
    subnet_id = dependency.vpc.outputs.public_subnets[0] // Public Subnet
    iam_instance_profile = dependency.ec2-instance-connect.outputs.iam_profile_name // Instance Connect - not required ssh/bastion
    tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
      Project =  "${local.common_vars.project-name}"
      Type = "Magento Web"
    }
}
