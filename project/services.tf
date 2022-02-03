resource "google_project_service" "project" {
  for_each = toset(var.services)

  project = google_project.project.project_id
  service = each.key
}
