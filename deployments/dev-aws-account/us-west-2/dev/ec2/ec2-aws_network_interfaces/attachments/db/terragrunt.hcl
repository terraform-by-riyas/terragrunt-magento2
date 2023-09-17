include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}
terraform {
  source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/aws_network_interface_attach"
}
dependencies {
  paths = ["../creation/db","../../ec2-servers/ec2-db-server-mariadb" ]
}
dependency "db" {
  config_path = "../creation/db"
}
dependency "instance" {
  config_path = "../../ec2-servers/ec2-db-server-mariadb"
}

inputs = {
  instance_id = dependency.instance.outputs.id
  network_interface_id =dependency.db.outputs.id

 tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
      Project =  "${local.common_vars.project-name}"
      Type = "Magento Web"
    }
}
