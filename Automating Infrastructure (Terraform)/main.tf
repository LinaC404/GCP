terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.55.0"
    }
  }
  # The prefix was added in Step3_2(Configure a remote backend) 
  backend "gcs" {
    bucket  = var.project_id
    prefix  = "terraform/state"
  }
}


provider "google" {
  project = var.project_id
  region = var.region
  zone = var.zone
}

module "instances" {
  source     = "./modules/instances"
}

# The reference was added in Step3_1(Configure a remote backend)
module "storage" {
  source     = "./modules/storage"
}
