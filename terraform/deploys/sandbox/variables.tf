variable "role_arn" {}
variable "session_name" {}
variable "region" {}
variable "vpc_id" { default = "vpc-4f3c2f2d" }
variable "app_name" { default = "GNTest" }
variable "instance_type" { default = "t2.micro" }
variable "subnet_id" { default = "subnet-bdecb6fb" }
variable "key_name" { default = "lnuk-lns-devops" }
variable "instance_profile" { default = "App" }
variable "guid" { default = "7e1ae8e8-a94c-495e-8fe7-e8aaff258b22" }
variable "asset_id" { default = "1461" }
variable "public_subnets" { default = ["subnet-bdecb6fb", "subnet-07ff3f61"] }
variable "dns_name" { default = "GNTest.lns.lnuksand.co.uk" }
variable "zone_id" { default = "Z22SWNIKR3P0S7" }
variable "ssl_cert" { default = "arn:aws:iam::466157028690:server-certificate/STAR.lns.lnuksand.co.uk-20190410" }
