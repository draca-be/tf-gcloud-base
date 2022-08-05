data "google_iam_policy" "project" {
  depends_on = [
    # This makes sure that during bootstrap, the core service account is created before we try to use it below
    google_service_account.core
  ]

  # The core account needs to be able to create service accounts in the project
  binding {
    role    = "roles/iam.serviceAccountAdmin"
    members = ["serviceAccount:${var.core.service_account}"]
  }

  # Allow core account to create roles in the project
  binding {
    role    = "roles/iam.roleAdmin"
    members = ["serviceAccount:${var.core.service_account}"]
  }

  # This is needed to enable API's in the project
  binding {
    role    = "roles/serviceusage.serviceUsageAdmin"
    members = ["serviceAccount:${var.core.service_account}"]
  }

  # This is needed for API quota billing so we assign it to all user who might use the API
  binding {
    role    = "roles/serviceusage.serviceUsageConsumer"
    members = concat(var.superusers.names, var.core.administrators)
  }

  # The core account can manage the network
  binding {
    role    = "roles/compute.networkAdmin"
    members = ["serviceAccount:${var.core.service_account}"]
  }

  # Project superusers and administrators can view all resources in their project
  binding {
    role    = "roles/viewer"
    members = concat(var.superusers.names, var.core.administrators)
  }

  binding {
    role    = var.core.roles.viewer
    members = concat(var.superusers.names, var.core.administrators)
  }

  # Project superuser bindings
  dynamic "binding" {
    for_each = var.superusers.roles
    content {
      role    = binding.value
      members = ["serviceAccount:${google_service_account.core.email}"]
    }
  }

  # Google-provided grants we need to add because otherwise changes keep popping up
  dynamic "binding" {
    for_each = var.google-service-accounts
    content {
      role = binding.value.role
      members = ["serviceAccount:service-${google_project.project.number}@${binding.value.name}"]
    }
  }

# Service Account bindings
  dynamic "binding" {
    for_each = flatten([
    for account in var.service-accounts : [
    for r in account.roles : {
      members = ["serviceAccount:${google_service_account.project[account.name].email}"]
      role    = r
    }
    ] if account.roles != null
    ])

    content {
      role    = binding.value.role
      members = binding.value.members
    }
  }

  # Manual users bindings
  dynamic "binding" {
    for_each = flatten([
    for user in var.users : [
    for r in user.roles : {
      members = user.names
      role    = r
    }
    ] if user.roles != null
    ])

    content {
      role    = binding.value.role
      members = binding.value.members
    }
  }
}

resource "google_project_iam_policy" "project" {
  project     = google_project.project.project_id
  policy_data = data.google_iam_policy.project.policy_data

  # Make sure all the APIs are enabled as they add auto-created users that might be needed in the policy
  depends_on = [
    google_project_service.project
  ]
}
