variable "project_id" {
  description = "gcp project id"
  type = number
}

resource "google_project_iam_binding" "project" {
  project = var.project_id
  role    = "roles/run.developer"

  members = [
    "serviceAccount:${var.project_id}@cloudbuild.gserviceaccount.com",
  ]
}

resource "google_cloudbuild_trigger" "cloudbuild_sample_api" {
  location = "us-central1"
  name     = "cloudbuild-sample-api"
  filename = "cloudbuild.yaml"

  github {
    owner = "Niccari"
    name  = "cloud_run_http_server_terraform_example"
    push {
      branch = "^main$"
    }
  }
  included_files = [
    "terraform/*.tf",
    "**/*.py",
    "Dockerfile",
    "Pipfile*",
    "requirements.txt",
  ]
}