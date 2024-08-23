
provider "aws" {
region="us-east-1"  
}

resource "aws_instance" "example" {
    ami=var.ami_type
    instance_type = var.aws_instance_type
    subnet_id = var.subnet_type
  
}