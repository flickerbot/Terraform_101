provider "aws" {
  region = "us-east-1"
}

variable "ami" {
    description= "this variable willbe used for ami " 
}

variable "instance_type" {
  description = "this value will be used for instance type "
 
}


resource "aws_instance" "Example" {
  ami=var.ami
  instance_type = var.instance_type
}