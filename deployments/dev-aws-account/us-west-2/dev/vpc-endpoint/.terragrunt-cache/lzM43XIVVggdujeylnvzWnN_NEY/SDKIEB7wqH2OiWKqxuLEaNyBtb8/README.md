# AWS Infra using Terraform, Terragrunt

## Very important: 

 - Step 0. Terraform uses the SSH protocol to clone the modules. Configured SSH keys will be used automatically. Add your SSH key to github account.   

**Right formatting for github modules:** 

    terraform {
      source  = "git::git@github.com:terraform-aws-modules/terraform-aws-vpc.git//modules/vpc-endpoints?ref=v5.1.2"
    }
