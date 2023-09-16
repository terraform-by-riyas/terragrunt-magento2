include {
  path = find_in_parent_folders()
}
locals {
  common_vars = yamldecode(file(find_in_parent_folders("common_vars.yaml")))
}

terraform {
  source  = "github.com/terraform-aws-modules/terraform-aws-security-group.git?ref=v5.1.0"  
}

dependencies {
  paths = ["../../vpc"]
}

dependency "vpc" {
  config_path = "../../vpc"
}
###########################################################
#https://registry.terraform.io/modules/terraform-aws-modules/security-group/aws/latest?tab=inputs
###########################################################

inputs = {

	name        = "opensearch"
	vpc_id      = dependency.vpc.outputs.vpc_id 
	ingress_cidr_blocks      = [dependency.vpc.outputs.vpc_cidr_block]
	# Open for self (rule or from_port+to_port+protocol+description)

# Open for self (rule or from_port+to_port+protocol+description)
  computed_ingress_with_self = [
    {
      from_port   = 443 
      to_port     = 443
      protocol    = 6
      description = "OpenSearch Dashboards in AWS OpenSearch Service with encryption in transit (TLS)-${dependency.vpc.outputs.name}"
      self        = true
    },
    {
      from_port   = 5601
      to_port     = 5601
      protocol    = 6
      description = "OpenSearch Dashboards-${dependency.vpc.outputs.name}"
      self        = true
    },
    {
      from_port = 9200
      to_port   = 9200
      protocol  = 6
      self      = true
      description = "OpenSearch REST API-${dependency.vpc.outputs.name}"
    },
    {
      from_port = 9250
      to_port   = 9250
      protocol  = 6
      self      = true
      description = "Cross-cluster search-${dependency.vpc.outputs.name}"
    },
    {
      from_port = 9300
      to_port   = 9300
      protocol  = 6
      self      = true
      description = "Node communication and transport-${dependency.vpc.outputs.name}"
    },
    {
      from_port = 9600
      to_port   = 9600
      protocol  = 6
      self      = true
      description = "Performance Analyzer-${dependency.vpc.outputs.name}"
    },
  ]

  number_of_computed_ingress_with_self = 6

egress_rules = ["all-all"]
    tags = {
      Terraform   = "true"
      Environment = "${local.common_vars.environment}"
    }
}
