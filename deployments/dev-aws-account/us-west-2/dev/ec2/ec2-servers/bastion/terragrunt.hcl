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
  paths = ["../../../aws-data", "../../../vpc", "../../../sgs/sg-bastion", "../../ssh-key","../../ec2-instance-connect"]
}

dependency "aws-data" {
  config_path = "../../../aws-data"
}
dependency "vpc" {
  config_path = "../../../vpc"
}

dependency "sg-bastion" {
  config_path = "../../../sgs/sg-bastion"
}
dependency "ssh-key" {
  config_path = "../../ssh-key"
}
dependency "ec2-instance-connect" {
  config_path = "../../ec2-instance-connect"
}


inputs = {
    name = "bastillion-server"
    ami = dependency.aws-data.outputs.amazon_linux2_aws_ami_id
    instance_type          = "t3.small"
    disable_api_termination = false
    create_spot_instance = true
    spot_wait_for_fulfillment = true
    key_name               = dependency.ssh-key.outputs.key-name
    monitoring             = false
    vpc_security_group_ids = [dependency.sg-bastion.outputs.security_group_id]
    subnet_id = dependency.vpc.outputs.public_subnets[0]
    iam_instance_profile = dependency.ec2-instance-connect.outputs.iam_profile_name
    tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
      Project =  "${local.common_vars.project-name}"
      Type = "bastillion"
    }
}
