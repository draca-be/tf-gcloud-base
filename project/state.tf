# Create a bucket to store the Terraform state for the project in
resource "google_storage_bucket" "state" {
  name     = "tf-${var.name}.${var.core.state.domain}"
  location = var.core.state.location
  project  = var.core.project

  uniform_bucket_level_access = true

  # Keep last 10 versions
  versioning {
    enabled = true
  }

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      num_newer_versions = 10
    }
  }

  force_destroy = true

  depends_on = [
    google_project.project
  ]
  # TODO: prevent public access once available
  # https://github.com/hashicorp/terraform-provider-google/issues/9519
}

# Set the bucket policy
data "google_iam_policy" "state" {
  binding {
    role    = "roles/storage.admin"
    members = [
      "projectOwner:${var.core.project}",
      "serviceAccount:${var.core.service_account}"
    ]
  }

  binding {
    role    = "roles/storage.objectAdmin"
    members = [
      "serviceAccount:${google_service_account.core.email}",
    ]
  }
}

resource "google_storage_bucket_iam_policy" "state" {
  bucket      = google_storage_bucket.state.name
  policy_data = data.google_iam_policy.state.policy_data
}
