variable "gcp_service_list" {
  type = list(string)
  default = [
    "cloudbuild.googleapis.com",
    "containerregistry.googleapis.com",
    "run.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

resource "google_project_service" "activate_gcp_services" {
  for_each = toset(var.gcp_service_list)
  service  = each.key
}