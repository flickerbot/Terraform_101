provider "aws" {
  region = "us-east-1"
}

variable "ami" {
    description= "this variable willbe used for ami " 
}

variable "instance_type" {
  description = "this value will be used for instance type "

  type =map(string)
  default = {
    "dev" = "t2.micro"
    "stage"="t2.small"
    "prod"="t2.large"
  }
 
}


module "aws_instance" {
  source = "./modules/ec2"
  ami = var.ami
  #instance_type = var.instance_type
  instance_type = lookup(var.instance_type,terraform.workspace,"t2.micro")
}