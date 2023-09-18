include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  source  = "github.com/terraform-aws-modules/terraform-aws-vpc.git?ref=v5.1.2"
  
}

dependencies {
  paths = ["../aws-data"]
}

dependency "aws-data" {
  config_path = "../aws-data"
}
###########################################################
# View all available inputs for this module:
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/5.1.2?tab=inputs
###########################################################

inputs = {
  # A list of availability zones names or ids in the region
  # type: list(string)
azs = slice((dependency.aws-data.outputs.available_aws_availability_zones_names),0,2)

  # The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden
  # type: string
  cidr = "10.0.0.0/16" //host range 10.0.0.1 - 10.0.255.254


  # Name to be used on all the resources as identifier
  # type: string
  name = "${local.common_vars.project-name}-${local.common_vars.environment}"

  # A list of private subnets inside the VPC
  # type: list(string)
  private_subnets = [for k,v in slice(( dependency.aws-data.outputs.available_aws_availability_zones_names),0,2): cidrsubnet("10.0.0.0/16", 8, k+10)]

  # A list of public subnets inside the VPC
  # type: list(string)
  public_subnets = [for k,v in slice((dependency.aws-data.outputs.available_aws_availability_zones_names),0,2): cidrsubnet("10.0.0.0/16", 8, k)]
  map_public_ip_on_launch = true
  # Enable NAT Gateway for the private subnet
  enable_nat_gateway = true 
  single_nat_gateway = true // for high availability, use multiple NAT gateways for each pvt subnets



    tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
    }
}
