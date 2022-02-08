module "project" {
  depends_on = [
    # Make sure the viewer role exists
    google_organization_iam_custom_role.viewer
  ]

  source = "../project"

  name    = local.core-name
  folder  = module.folder.name
  billing = var.billing

  core = local.core

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
