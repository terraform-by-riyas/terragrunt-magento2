include {
  path = find_in_parent_folders()
}

terraform {
  source  = "github.com/terraform-aws-modules/terraform-aws-ec2-instance.git?ref=v5.5.0"
  
}

inputs = {
    name = "single-instance"
    instance_type          = "t2.micro"
    create_spot_instance = true
    key_name               = "temp-key"
    monitoring             = true
    vpc_security_group_ids = ["sg-069d560c89e9d9119"]
    tags = {
      Terraform   = "true"
      Environment = "dev"
    }
}
