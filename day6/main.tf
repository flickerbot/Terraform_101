provider "aws" {
  region = "us-east-1"
}


resource "aws_instance" "example" {
  ami = "ami-0e001c9271cf7f3b9"
  instance_type = "t3.small"
}



provider "vault" {
  address = "http://54.86.22.87:8080"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "2c6a4447-3d23-85c4-2d95-e715c4ce5a35"
      secret_id = "83473e1c-62c6-4c23-c323-b69ca4fac981"
    }
  }
}



data "vault_kv_secret_v2" "example" {
  mount="kv"
  name="name"
}


resource "aws_instance" "new" {
    
    ami = "ami-0e001c9271cf7f3b9"
  instance_type = "t3.small"

  tags = {
    secret=data.vault_kv_secret_v2.example.data["name"]
  }
}   