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
  region     = "ap-south-1"
}

provider "mongodbatlas" {
  public_key  = var.atlas_public_key
  private_key = var.atlas_private_key
}

