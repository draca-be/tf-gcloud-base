output "project" {
  value = google_project.project.project_id
}

output "service_account" {
  value = google_service_account.core.email
}

output "terraform_bucket" {
  value = google_storage_bucket.state.url
}
