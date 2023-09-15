resource "aws_key_pair" "tf-key-pair" {
key_name = "tf-key-pair"
public_key = var.public_key 
}
