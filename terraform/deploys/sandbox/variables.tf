variable "role_arn" {}
variable "session_name" {}
variable "region" {}
variable "vpc_id" { default = "vpc-0951357d9d636a79b" }
variable "app_name" { default = "GeorgeTest" }
variable "instance_type" { default = "t2.micro" }
variable "subnet_id" { default = "subnet-09040bf6b7c2e62f3" }
variable "key_name" { default = "lnuk-lns-devops" }
variable "instance_profile" { default = "App" }
variable "guid" { default = "7e1ae8e8-a94c-495e-8fe7-e8aaff258b22" }
variable "asset_id" { default = "1461" }
variable "public_subnets" { default = ["subnet-0f3070eed18efff29", "subnet-063b32540e35f5680", "subnet-08a3497f0b7ad16fc"] }
variable "dns_name" { default = "GeorgeTest.lns.lnuksand.co.uk" }
variable "zone_id" { default = "Z22SWNIKR3P0S7" }
variable "ssl_cert" { default = "arn:aws:iam::466157028690:server-certificate/STAR.lns.lnuksand.co.uk-20190410" }
