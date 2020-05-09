terraform {
  backend "s3" {
    bucket = "us-east-1-task"
    key    = "interview"
    region = "us-east-1"
  }
}