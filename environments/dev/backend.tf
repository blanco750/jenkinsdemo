terraform {

  backend "s3" {
    bucket = "jenkins101-demo-1"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}