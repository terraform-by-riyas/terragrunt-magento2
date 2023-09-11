# Set common variables for the environment
locals {
  name           = "magento-2"
  environment    = "dev"
  state_bucket   = "tf-terragrunt-statelock" 
  dynamodb_table = "tf-terragrunt-statelock"
}