output "aws_region" {
  description = "Details about selected AWS region"
  value       = data.aws_region.selected
}

output "available_aws_availability_zones_names" {
  description = "A list of the Availability Zone names available to the account"
  value       = data.aws_availability_zones.available.names
}

output "available_aws_availability_zones_zone_ids" {
  description = "A list of the Availability Zone IDs available to the account"
  value       = data.aws_availability_zones.available.zone_ids
}

output "amazon_linux2_aws_ami_id" {
  description = "AMI ID of Amazon Linux 2"
  value       = data.aws_ami.amazon_linux2.id
}

output "ubuntu_arm_graviton_22_04lts" {
  description = "AMI ID of Ubuntu 22.04 supported by AWS Graviton Processors"
  value       = data.aws_ami.ubuntu_arm_graviton_22_04lts.id
}