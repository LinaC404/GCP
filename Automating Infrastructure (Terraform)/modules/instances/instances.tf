resource "google_compute_instance" "tf-instance-1" {
  name         = "tf-instance-1"
  # The machine type was modified in Step5(Modify and update infrastructure)
  machine_type = "n1-standard-2"
  zone         = var.zone
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network = "terraform-vpc"
    network = "default"
  }
}

resource "google_compute_instance" "tf-instance-2" {
  name         = "tf-instance-2"
  # The machine type was modified in Step5(Modify and update infrastructure)
  machine_type = "n1-standard-2"
  zone         = var.zone
  allow_stopping_for_update = true
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    # Modifed in Step6_2(Use a module from the Registry)
    network = "terraform-vpc"
    subnetwork = "subnet-01"
  }
}

# This resource was added in Step5(Modify and update infrastructure) deleted in Step6(Taint and destroy resources).  
resource "google_compute_instance" "tf-instance-3" {
  name         = "tf-instance-3"
  machine_type = "n1-standard-2"
  zone         = var.zone
  allow_stopping_for_update = true
  
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    # Modifed in Step6_2(Use a module from the Registry)
    network = "terraform-vpc"
    subnetwork = "subnet-02"
  }
}

