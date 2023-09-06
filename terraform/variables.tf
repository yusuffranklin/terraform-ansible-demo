variable "security_group_name" {
    default = "http-server-sg"
}

variable "aws_key_pair" {
  default = "C:/Users/User/Desktop/ec2-keypair.pem"
}

variable "aws_key_pair_name" {
    default = "ec2-keypair"
}

variable "aws_instance_username" {
    default = "ec2-user"
}