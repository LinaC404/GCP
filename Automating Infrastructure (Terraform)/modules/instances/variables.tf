variable "project_id" {
    description = "The ID of the project in which to provision resources."
    type        = string
    default     = "<FILL IN YOUR PROJECT ID HERE>"
}

variable "region" {
    default = "us-central1"
}

variable "zone" {
    default = "us-central1-a"
}
