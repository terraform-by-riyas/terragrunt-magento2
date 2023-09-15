//Create an instance profile to attach with all instances.

resource "aws_iam_instance_profile" "resources-iam-profile" {
name = "ec2_profile"
role = aws_iam_role.resources-iam-role.name
}

//Create aws IAM role

resource "aws_iam_role" "resources-iam-role" {
name        = var.ssm-role-name
description = "The role for the resources EC2"

assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": {
"Effect": "Allow",
"Principal": {"Service": "ec2.amazonaws.com"},
"Action": "sts:AssumeRole"
}
}
EOF

tags = {
tf = "yes"
}
}


// attach the AmazonSSMManagedInstanceCore policy to the above role

resource "aws_iam_role_policy_attachment" "resources-ssm-policy" {
role       = aws_iam_role.resources-iam-role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}