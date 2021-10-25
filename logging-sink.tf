resource "random_id" "server" {
  byte_length = 8
}

resource "google_storage_bucket" "gke-log-bucket" {
  name          = "stackdriver-gke-logging-bucket-${random_id.server.hex}"
  storage_class = "NEARLINE"
  force_destroy = true
  uniform_bucket_level_access = true
}
resource "google_bigquery_dataset" "gke-bigquery-dataset" {
  dataset_id                  = "gke_logs_dataset"
  location                    = "US"
  default_table_expiration_ms = 3600000

  labels = {
    env = "default"
  }
}

resource "google_logging_project_sink" "bigquery-sink" {
  name        = "gke-bigquery-sink"
  destination = "bigquery.googleapis.com/projects/${var.project}/datasets/${google_bigquery_dataset.gke-bigquery-dataset.dataset_id}"
  filter      = "resource.type = k8s_container"

  unique_writer_identity = true
}
resource "google_project_iam_binding" "log-writer-bigquery" {
  role = "roles/bigquery.dataEditor"

  members = [
    google_logging_project_sink.bigquery-sink.writer_identity,
  ]
}



resource "google_logging_project_sink" "storage-sink" {
  name        = "gke-storage-sink"
  destination = "storage.googleapis.com/${google_storage_bucket.gke-log-bucket.name}"
  filter      = "resource.type = k8s_container"

  unique_writer_identity = true
}



resource "google_project_iam_binding" "log-writer-storage" {
  role = "roles/storage.objectCreator"

  members = [
    google_logging_project_sink.storage-sink.writer_identity,
  ]
}
