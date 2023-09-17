variable "ec2" {
  description  = "EC2 instances names and types included in AutoScaling groups"
  default      = {
    varnish    = "m6g.large"
    frontend   = "c6g.xlarge"
    admin      = "c6g.xlarge"
   }
}
# variable "IAM_INSTANCE_PROFILE" {}
variable "PARAMETERSTORE_NAME" {
    default = "magento-dev-ss-store-name-hardcoded"
}

variable "ami_name" {
    default = "ami-0c79a55dda52434da"
}

