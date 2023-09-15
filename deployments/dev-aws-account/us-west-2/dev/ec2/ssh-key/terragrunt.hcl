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
 #  filename = "${get_terragrunt_dir()}-ssh-key.pem"
    public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLzywQHQP34Uiq+GY85YvqSuDcV1CCmmj4aPDhPIiImlGjkVxBtQUt1cMOqCzo5KA+QvrPn6yNUc0JUH0hB/T73HIoIWoByevy7A9OQZzzWGIvACKpnt5wnRJVVQ+wImmU/GUG0+7zHhXhAY3F5RjJx19WuJk3buh0LG8Hr5CKpYO0ypWHDhesQ3rouFSSK933tk3ruktt4rP/1wl4SAgavBHytEidG+0YG1/jbRD/JHtzH68K+VcLEBeoEegGuI8v0ABKWMvnoeJWCJ9rzvpp6EoAertY7QbWpnz0glhwIou/GYpk6aSObkqnk3e6TopCuIO+6TbOUvieslAqdMKb ssh-key-generated-for-tf"
    tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
      Project =  "${local.common_vars.project-name}"
      Type = "bastillion"
    }
}
