variable "region" {
  default = "eu-west-2"
  description = "AWS Region"
}


variable "cidr_block" {
  default = "10.0.0.0/16"
  description = "VPC cidr"
}


variable "pub-sub-1-cidr_block" {
  default = "10.0.1.0/24"
  description = "pub-sub-1 cidr"
}

variable "prvt-sub-2-cidr_block" {
  default = "10.0.2.0/24"
  description = "prvt-sub-2 cidr"
}

variable "aws_security_group" {
  default = "allow access to port 80 and 22"
  description = "security-group-aws_security_group"
}

variable "E-VPC-aws_instance" {
  default = "ami-0aaa5410833273cfe"
  description = "aws_instance"
}
