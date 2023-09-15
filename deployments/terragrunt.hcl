/******************************
TERRAGRUNT CONFIGURATION
******************************/

locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
  # Load account, region and environment variables 
  account_vars      = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars       = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  environment_vars  = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need with the backend configuration
  aws_region      = local.region_vars.locals.aws_region
  environment     = local.common_vars.environment
  
}

# Configure the Terragrunt remote state to utilize a S3 bucket and state lock information in a DynamoDB table. 
# And encrypt the state data.
remote_state {
  backend   = "s3"
  generate  = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config    = {
    bucket         = "${local.common_vars.state_bucket}-${get_aws_account_id()}"
    key            = "terragrunt/magento2/${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.region_vars.locals.aws_region}"
    encrypt        = true
    dynamodb_table = "${local.common_vars.dynamodb_table}"
    profile        = "${local.common_vars.aws_profile_name}"
  }
}

# Combine all account, region and environment variables as Terragrunt input parameters.
# The input parameters can be used in Terraform configurations as Terraform variables.  
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)

terraform {
  extra_arguments "aws_profile" {
    commands = [
      "init",
      "apply",
      "refresh",
      "import",
      "plan",
      "taint",
      "untaint"
    ]

    env_vars = {
      AWS_PROFILE = "${local.common_vars.aws_profile_name}"
    }
  }
}

generate "provider" {
    path      = "provider.tf"
    if_exists = "overwrite"
    contents = <<EOF
provider "aws" {
  profile = "${local.common_vars.aws_profile_name}"
  region = "${local.region_vars.locals.aws_region}"
}
EOF
}
