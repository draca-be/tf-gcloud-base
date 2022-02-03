# Service account in the core project
resource "google_service_account" "core" {
  project     = var.core.project
  account_id = var.name
}

# Policy for service account in the core project
data "google_iam_policy" "core" {
  binding {
    members = concat(var.core.administrators, var.superusers.names)
    role    = "roles/iam.serviceAccountTokenCreator"
  }
}

resource "google_service_account_iam_policy" "core" {
  service_account_id = google_service_account.core.name
  policy_data = data.google_iam_policy.core.policy_data
}

#locals {
#  # First reshape regular service accounts, then add the superuser account
#  service-accounts = merge({
#  for account in var.service-accounts : account.name => {
#    project     = google_project.project.project_id
#    impersonate = account.impersonate
#  }
#}
#
resource "google_service_account" "project" {
  for_each = toset([ for account in var.service-accounts : account.name ])

  project    = google_project.project.project_id
  account_id = each.key
}
#
#data "google_iam_policy" "service-account" {
#  for_each = {for k, v in local.service-accounts : k => v if v.impersonate != null}
#
#  binding {
#    role    = "roles/iam.serviceAccountTokenCreator"
#    members = each.value.impersonate
#  }
#}
#
#resource "google_service_account_iam_policy" "service-account" {
#  for_each = data.google_iam_policy.service-account
#
#  service_account_id = google_service_account.project[each.key].name
#  policy_data        = each.value.policy_data
#}
#
