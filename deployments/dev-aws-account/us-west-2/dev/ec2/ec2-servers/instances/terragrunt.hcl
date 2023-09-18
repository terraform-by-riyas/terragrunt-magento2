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

multiple_instances = {
    db = {
      instance_type           = "r7g.large"
      disable_api_termination = true
      ebs_optimized           = true
      ami                     = dependency.aws-data.outputs.ubuntu_arm_graviton_22_04lts
      key_name                = dependency.ssh-key.outputs.key-name
      monitoring              = false
      vpc_security_group_ids  = [dependency.sg-mariadb.outputs.security_group_id]
      iam_instance_profile    = dependency.ec2-instance-connect.outputs.iam_profile_name
      subnet_id               = dependency.vpc.outputs.private_subnets[0]
      availability_zone       = dependency.vpc.outputs.azs[0]

      root_block_device = [
        {
          encrypted           = false
          volume_type         = "gp3"
          volume_size         = 30
        }
      ]
      ebs_block_device        = [
        {
          encrypted           = false
          volume_type         = "gp3"
          volume_size         = 30
        }
      ]
    },
    varnish = {},
    redis = {},
    admin = {},
    elastic_search = {}

  }
environment = "dev"
}

