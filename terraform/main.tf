resource "aws_default_vpc" "default_vpc" {

}

resource "aws_security_group" "http_server_sg" {
    name    = var.security_group_name
    vpc_id  = aws_default_vpc.default_vpc.id

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        name = "http_server_sg"
    }
}

module "ec2_instance" {
    source      = "terraform-aws-modules/ec2-instance/aws"

    for_each    = toset(["ansible", "load-balancer", "one", "two"])

    name        = "instance-${each.key}"

    ami                    = data.aws_ami.aws_linux_2_latest.id
    instance_type          = "t2.micro"
    key_name               = var.aws_key_pair_name
    monitoring             = true
    vpc_security_group_ids = [aws_security_group.http_server_sg.id]
    subnet_id              = data.aws_subnets.default_subnets.ids[0]

    tags = {
        Terraform   = "true"
        Environment = "dev"
    }
}