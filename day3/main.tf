provider "aws" {
  region ="us-east-1"
}

resource "aws_instance" "New_Instance" {
   ami ="ami-066784287e358dad1"
   instance_type = "t2.micro"
subnet_id= "subnet-0db26d954d5ff42e2"


}


resource "aws_dynamodb_table" "DEMO_dynamodb" {
  name= "backend_lock"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"
   attribute {
    name = "LockID"
    type = "S"
  }

}