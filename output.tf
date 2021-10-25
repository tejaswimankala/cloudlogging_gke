output "network" {
  value = google_compute_subnetwork.default.network
}

output "subnetwork_name" {
  value = google_compute_subnetwork.default.name
}

output "cluster_name" {
  value = google_container_cluster.default.name
}

output "cluster_region" {
  value = var.region
}

output "cluster_location" {
  value = google_container_cluster.default.location
}

output "load-balancer-ip" {
  value = google_compute_address.default.address
}

output "bigquery-sink"{
    value = google_logging_project_sink.bigquery-sink.name
}

output "storage-sink"{
    value = google_logging_project_sink.storage-sink.name
}

output "storage-bucket"{
    value = google_storage_bucket.gke-log-bucket.name
}

output "bigquery-dataset"{
    value = google_bigquery_dataset.gke-bigquery-dataset.dataset_id
}
