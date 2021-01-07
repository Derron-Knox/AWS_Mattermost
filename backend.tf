terraform {
  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "terraformstatefile"
    bucket  = "INSERT backend bucket Name Here"
  }
}