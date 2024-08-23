provider "aws"{
    region="ap-south-1"
}

module "ec2" {
  source = "../modules/ec2"
  ami_type = "ami-02b49a24cfb95941c"
  aws_instance_type = "t3.micro"
  subnet_type = "subnet-060f7e3f6ccbfff64"
}