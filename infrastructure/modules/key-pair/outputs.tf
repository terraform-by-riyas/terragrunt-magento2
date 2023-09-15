output "key-name" {
	description = "generated ssh key name"
 	value = aws_key_pair.tf-key-pair.key_name 
}
