include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
   multiple_instances = {
    one = {
      instance_type     = "t3.micro"

      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp3"
          throughput  = 200
          volume_size = 50
          tags = {
            Name = "my-root-block"
          }
        }
      ]
    }
    two = {
      instance_type     = "t3.small"

      root_block_device = [
        {
          encrypted   = true
          volume_type = "gp2"
          volume_size = 50
        }
      ]
    }
    three = {
      instance_type     = "t3.medium"

    }
  }
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

 

}
