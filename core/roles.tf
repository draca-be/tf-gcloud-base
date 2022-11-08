resource "google_organization_iam_custom_role" "viewer" {
  org_id = var.organization-id

  role_id     = "${var.unique-id}.viewer"
  title       = "${var.unique-id}.viewer"
  description = "Read-only access for usage in cloud console"
  permissions = [
    "storage.buckets.get",
    "storage.buckets.getIamPolicy",
    "artifactregistry.repositories.get",
    "artifactregistry.repositories.list",
  ]
}

locals {
  roles = {
    viewer = google_organization_iam_custom_role.viewer.id
  }
}
