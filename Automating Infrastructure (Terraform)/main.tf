terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.55.0"
    }
  }
  
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

module "storage" {
  source     = "./modules/storage"
}
