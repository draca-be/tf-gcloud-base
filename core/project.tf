locals {
  name            = var.name != null ? var.name : "${var.unique-id}-core"
  service_account = "${local.name}@${local.name}.iam.gserviceaccount.com"
}

module "project" {
  depends_on = [
    # Make sure the viewer role exists
    google_organization_iam_custom_role.viewer
  ]

  source = "../project"

  name    = local.name
  folder  = module.folder.name
  billing = var.billing

  # Since we are bootstrapping we can't provide our own output and we need to provide these values ourselves
  core = {
    project         = local.name
    service_account = local.service_account
    organization-id = var.organization-id
    administrators  = var.administrators
    state           = var.state
    roles           = local.roles
  }

  # We inject storage admin rights since we are bootstrapping and we can't use the normal path through service-accounts.
  # This means some additional permissions are assigned to the core service account but that's okay because they are
  # - covered by other permissions
  # - possible to gain through self-elevation.
  # - already given to the same group of users that can impersonate this account (administrators)
  users = [{
    names = ["serviceAccount:${local.service_account}"]
    roles = ["roles/storage.admin"]
  }]

  services = [
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "orgpolicy.googleapis.com",
    "serviceusage.googleapis.com",
    "cloudbilling.googleapis.com",
  ]
}
