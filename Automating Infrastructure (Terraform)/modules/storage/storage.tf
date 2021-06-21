provider "google" {
  project     = "<FILL IN YOUR PROJECT ID HERE>"
  region      = "us-central-1"
}

resource "google_storage_bucket" "test-bucket-for-state" {
  name        = "<FILL IN YOUR PROJECT ID HERE>"
  location    = "US"
  uniform_bucket_level_access = true
}
