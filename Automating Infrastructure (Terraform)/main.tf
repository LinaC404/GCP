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


# The reference was added in Step6_1(Use a module from the Registry)
module "vpc" {
    source  = "terraform-google-modules/network/google"
    version = "~> 3.2.2"

    project_id   =  var.project_id
    network_name = "terraform-vpc"
    routing_mode = "GLOBAL"

    subnets = [
        {
            subnet_name           = "subnet-01"
            subnet_ip             = "10.10.10.0/24"
            subnet_region         = "us-central1"
        },
        {
            subnet_name           = "subnet-02"
            subnet_ip             = "10.10.20.0/24"
            subnet_region         = "us-central1"
        },
    ]
}
