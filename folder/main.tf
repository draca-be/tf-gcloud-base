resource "google_folder" "folder" {
  display_name = var.name
  parent       = var.parent
}

data "google_iam_policy" "folder" {
  binding {
    role = "roles/resourcemanager.folderViewer"

    members = var.access
  }
}

resource "google_folder_iam_policy" "folder" {
  folder      = google_folder.folder.name
  policy_data = data.google_iam_policy.folder.policy_data
}
