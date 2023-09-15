include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
 source  = "${dirname(find_in_parent_folders())}/..//infrastructure/modules/key-pair" 
}

inputs = {
   filename = "${get_terragrunt_dir()}-ssh-key.pem"

    tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
      Project =  "${local.common_vars.project-name}"
      Type = "bastillion"
    }
}
