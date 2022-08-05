locals {
  core-name       = var.core-name != null ? var.core-name : "${var.unique-id}-core"
  network-name    = var.network-name != null ? var.network-name : "${var.unique-id}-network"
  service_account = "${local.core-name}@${local.core-name}.iam.gserviceaccount.com"

  # Since we are bootstrapping we can't provide our own output and we need to provide these values ourselves
  core = {
    project         = local.core-name
    service_account = local.service_account
    organization-id = var.organization-id
    administrators  = var.administrators
    state           = var.state
    roles           = local.roles
    network         = ""
  }
}
