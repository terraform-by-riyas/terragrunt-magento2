include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}
terraform {
  source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/aws_network_interface"
}
dependencies {
  paths = ["../../../vpc", "../../ec2-servers/ec2-db-server-mariadb"]
}
dependency "vpc" {
  config_path = "../../../../vpc"
}
dependency "db" {
  config_path = "../../ec2-servers/ec2-db-server-mariadb"
}


inputs = {
  aws_subnet_id = dependency.vpc.outputs.private_subnets[0]
  private_ips = ["10.0.10.10"]
  name = "eni-DB-${local.common_vars.project-name}-${local.common_vars.environment}"
  instance_id = dependency.db.outputs.id
  description = "eni for the DB server"
 # security_groups = 
 tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
      Project =  "${local.common_vars.project-name}"
      Type = "Magento Web"
    }
}
