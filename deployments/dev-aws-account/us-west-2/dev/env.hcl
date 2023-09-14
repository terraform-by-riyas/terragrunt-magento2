# Set common variables for the environment
locals {
  name           = "magento-2"
  state_bucket   = "tf-terragrunt-statelock" 
  dynamodb_table = "tf-terragrunt-statelock"
}