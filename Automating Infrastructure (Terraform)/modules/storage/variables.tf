
variable "project_id" {
    description = "The ID of the project in which to provision resources."
    type        = string
    default     = "qwiklabs-gcp-03-7547abdb50f8"
}

variable "region" {
    default = "us-central1"
}

variable "zone" {
    default = "us-central1-a"
}
