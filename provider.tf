terraform {
  required_version = "> 1.7.1"
  required_providers {
    mongodbatlas = {
      source  = "mongodb/mongodbatlas"
      version = "1.4.6"
    }
  }
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = "ap-south-1"
}
provider "mongodbatlas" {
  public_key  = var.public_key
  private_key = var.private_key
}

