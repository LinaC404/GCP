provider "google" {
  project     = "qwiklabs-gcp-03-c5c3b3af1a23"
  region      = "us-central-1"
}

resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "qwiklabs-gcp-03-c5c3b3af1a23"
  location    = "US"
  uniform_bucket_level_access = true
}
