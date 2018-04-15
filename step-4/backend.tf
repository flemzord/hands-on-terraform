terraform {
  backend "s3" {
    bucket = "devoxx_bucket"
    key    = "tfstate/"
    region = "eu-west-3"
  }
}
