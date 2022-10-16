resource "google_cloudbuild_trigger" "cloudbuild_sample_api" {
  location = "us-central1"
  name     = "cloudbuild-sample-api"

  trigger_template {
    branch_name = "main"
    repo_name   = "cloudrun_api_terraform_sample"
  }
  filename = "cloudbuild.yaml"
}