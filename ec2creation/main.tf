provider "aws" {
region ="us-east-1"       #this will be default 
}

resource "aws_instance" "rishi" {
  ami                     = "ami-0e001c9271cf7f3b9"
  instance_type           = "t3.micro"
}