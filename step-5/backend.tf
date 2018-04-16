terraform {
  backend "s3" {
    bucket = "devoxx-bucket"
    key    = "hands-on"
    region = "eu-west-3"
  }
}
