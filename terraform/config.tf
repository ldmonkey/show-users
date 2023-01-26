terraform {
  backend "s3" {
    bucket = "all-users-python-flask-webapp"
    key    = "tfstate"
    region = "eu-central-1"
  }
}

provider "aws" {
  region = var.region
}
