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
