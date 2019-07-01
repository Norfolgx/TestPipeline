variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_security_token" {}
variable "region" { default = "eu-west-1" }
variable "vpc_id" { default = "vpc-fa0cee9f" }
variable "app_name" { default = "GeorgeTest" }
variable "ami" { default = "ami-0556095f49d03649b" }
variable "instance_type" { default = "t2.micro" }
variable "subnet_id" { default = "subnet-893fc7fe" }
variable "key_name" { default = "lnuk-lns-devops" }
variable "instance_profile" { default = "App" }
variable "guid" { default = "7e1ae8e8-a94c-495e-8fe7-e8aaff258b22" }
variable "asset_id" { default = "1461" }