
variable "project_name" {
  description = "gcp project name"
  type = string
}

resource "google_cloud_run_service" "configure_cloud_run_service" {
  name                       = "sample-api"
  location                   = "us-central1"
  autogenerate_revision_name = true # 自動でリビジョン末尾の識別文字列を入れるために必要

  template {
    spec {
      timeout_seconds       = 300
      container_concurrency = 50
      containers {
        image = "us.gcr.io/${var.project_name}/sample-api" # すでにimageがアップロード済みでないといけない
        resources {
          limits = {
            "memory" : "256Mi",
            "cpu" : "1"
          }
        }
      }
    }
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "0"
        "autoscaling.knative.dev/maxScale" = "5"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  lifecycle {
    ignore_changes = [
      # gcloudからデプロイしたとき、以下のパラメータが入る。変更差分として判定したくないのでチェック対象から外す
      template[0].metadata[0].annotations["client.knative.dev/user-image"],
      template[0].metadata[0].annotations["run.googleapis.com/client-name"],
      template[0].metadata[0].annotations["run.googleapis.com/client-version"],
      # Clour Buildからビルド・デプロイしたとき、以下のパラメータが入る。変更差分として判定したくないのでチェック対象から外す
      template[0].metadata[0].labels,
      template[0].spec[0].containers["image"]
    ]
  }
}
