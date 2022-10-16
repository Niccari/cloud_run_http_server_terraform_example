terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.40.0"
    }
  }
  required_version = ">= 1.3"
  backend "gcs" {}
}

variable "project_name" {
  type    = string
}

provider "google" {
  project                     = var.project_name
  region                      = "us-central1"
  impersonate_service_account = "terraform@${var.project_name}.iam.gserviceaccount.com"
}

module "api" {
  source = "./module/api"
}

module "cloudbuild" {
  source     = "./module/cloudbuild"
  depends_on = [module.api]
}

module "cloudrun" {
  source       = "./module/cloudrun"
  depends_on   = [module.api]
  project_name = var.project_name
}
