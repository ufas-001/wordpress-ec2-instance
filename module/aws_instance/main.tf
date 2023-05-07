resource "aws_instance" "wordpress" {
  ami                    = var.aws-ami-id
  instance_type          = "t2.micro"
  key_name               = "terraformkey"
  vpc_security_group_ids = [var.aws-security-group-id]
  tags = {
    "Name" = "Wordpress-server"
  }
   user_data = file(var.file-path)
}
