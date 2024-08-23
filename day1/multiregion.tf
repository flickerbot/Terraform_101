resource "aws_instance" "example" {
  ami = "ami-0123456789abcdef0"
  instance_type = "t2.micro"
  provider = "aws.us-east-1"
}

resource "aws_instance" "example2" {
  ami = "ami-0123456789abcdef0"
  instance_type = "t2.micro"
  provider = "aws.us-west-2"
}


resource "aws_instance" "example3" {
  ami = "ami-0123456789abcdef0"
  instance_type = "t2.micro"
  provider = "aws.awsrishitest"
}