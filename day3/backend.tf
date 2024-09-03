terraform {
  backend "s3" {
    bucket = "testbuckk101"
    key    = "rishi/remote-backend"
    region = "us-east-1"
    dynamodb_table = "backend_lock"
  }
}
