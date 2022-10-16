variable "project_id" {
  description = "gcp project id"
  type = number
}

resource "google_project_iam_member" "cloudbuild_iam" {
  for_each = toset([
    "roles/run.developer",
    "roles/iam.serviceAccountUser"
  ])
  role    = each.key
  member  = "serviceAccount:${var.project_id}@cloudbuild.gserviceaccount.com"
  project = var.project_id
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
    "**/*.py",
    "Dockerfile",
    "Pipfile*",
    "requirements.txt",
  ]
}