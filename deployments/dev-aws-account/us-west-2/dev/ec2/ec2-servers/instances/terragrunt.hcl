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

multiple_instances = {
    one = {
      instance_type     = "t3.micro"
      availability_zone = element(dependency.vpc.outputs.azs, 0)
      subnet_id         = element(dependency.vpc.outputs.public_subnets,0)
      create_spot_instance = false
      spot_wait_for_fulfillment = true
      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp3"
          throughput  = 125
          volume_size = 10
          tags = {
            Name = "my-root-block"
          }
        }
      ]
      tags = {
      Name = "one"
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
      Project =  "${local.common_vars.project-name}"
      Type = "Magento Web Admin"
    }
    }
  }
}


