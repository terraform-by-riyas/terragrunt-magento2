# packer amazon
# pre-build custom ami
# # ---------------------------------------------------------------------------------------------------------------------#
# Set packer amazon plugin version
# # ---------------------------------------------------------------------------------------------------------------------#
packer {
  required_plugins {
    amazon = {
      version = ">= 1.9.3"
      source  = "github.com/hashicorp/amazon"
    }
  }
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Packer variables from terraform
# # ---------------------------------------------------------------------------------------------------------------------#
// variable "IAM_INSTANCE_PROFILE" {}
variable "INSTANCE_NAME" {}
// variable "PARAMETERSTORE_NAME" {}
# # ---------------------------------------------------------------------------------------------------------------------#
# Get environment variables from SSM ParameterStore
# # ---------------------------------------------------------------------------------------------------------------------#
// data "amazon-parameterstore" "env" {
//   name = "${var.PARAMETERSTORE_NAME}"
// }
locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
//   var = "${jsondecode(data.amazon-parameterstore.env.value)}"
}
# # ---------------------------------------------------------------------------------------------------------------------#
# Create AMI Builder (EBS backed)
# # ---------------------------------------------------------------------------------------------------------------------#
source "amazon-ebs" "latest-ami" {
  ami_name        = "M2-web-${local.timestamp}"
  ami_description = "AMI forMagento - Packer Build ${local.timestamp}"
  region          = "us-west-2"
  source_ami      = "ami-0c79a55dda52434da"
//   iam_instance_profile = "${var.IAM_INSTANCE_PROFILE}"
  security_group_id = "sg-0282411ebada99753"
  subnet_id       = "subnet-9586e3be"
  ssh_username    = "ubuntu"
  instance_type   = "c6g.large"
  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = "10"
    volume_type = "gp3"
    delete_on_termination = true
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
    http_put_response_hop_limit = 1
  }
  snapshot_tags = {
    Name = "magento-dev-BAAR-${local.timestamp}"
  }
}

build {
  name    = "latest-ami"
  sources = [
    "source.amazon-ebs.latest-ami"
  ]

  provisioner "shell" {
    script = "./build.sh"
    pause_before = "10s"
    timeout      = "60s"
    environment_vars = [
"INSTANCE_NAME=${var.INSTANCE_NAME}",
"PARAMETERSTORE_NAME=${var.PARAMETERSTORE_NAME}"
]
 }
  
  post-processor "manifest" {
        output = "./manifest_for_${var.INSTANCE_NAME}.json"
        strip_path = true
        custom_data = {
          timestamp = "${local.timestamp}"
        }
    }
  
}