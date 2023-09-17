//////////////////////////////////////////////////////[ PACKER BUILDER ]//////////////////////////////////////////////////


# # ---------------------------------------------------------------------------------------------------------------------#
# Create custom AMI with Packer Builder
# # ---------------------------------------------------------------------------------------------------------------------#
resource "null_resource" "packer" {
  for_each = var.ec2
  provisioner "local-exec" {
    working_dir = "${abspath(path.root)}/packer"
    command = <<EOF
PACKER_LOG=1 PACKER_LOG_PATH="packerlog" /usr/bin/packer build \
-var INSTANCE_NAME=${each.key} \
packer.pkr.hcl
EOF
  }

# triggers (Map of String) A map of arbitrary strings that, when changed, 
# will force the null resource to be replaced, re-running any associated provisioners.

#  triggers = {
#     ami_creation_date = data.aws_ami.distro.creation_date
#     build_script      = filesha256("${abspath(path.root)}/packer/build.sh")
#   }
}