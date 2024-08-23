//provider "aws" {
//region = "us-east-1"
// }

provider "aws" {
  alias = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias = "us-west-2"
  region = "us-west-2"
}

//provider "awsrishitest" {                    //this will not work , provider must be aws we can use some other name in alias 
  //alias = "ap-south-1"
  //region = "ap-south-1"
// }


provider "aws" {
  alias = "awsrishitest"
  region = "us-west-2"
}