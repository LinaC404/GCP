resource "google_storage_bucket" "test-bucket-for-state" {
  name        = var.project_id
  location    = "US"
  uniform_bucket_level_access = true
  force_destroy = true
}
