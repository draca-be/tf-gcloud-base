resource "google_project" "project" {
  name                = var.name
  project_id          = var.name
  folder_id           = var.folder
  billing_account     = var.billing
  skip_delete         = true
  auto_create_network = false
}

# Default service accounts are prevented by policy but in some cases (bootstrapping, importing projects) they might
# already exist so we try to deprivilege them
resource "google_project_default_service_accounts" "project" {
  project = google_project.project.project_id
  action  = "DEPRIVILEGE"
}
