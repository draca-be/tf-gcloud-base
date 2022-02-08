# We won't use the default service account and storage bucket but leave it as has no cost. Potentially in the future
# network can be managed separately and we'll need it anyway.
module "network" {
  source = "../project"

  name    = local.network-name
  folder  = module.folder.name
  billing = var.billing

  core = local.core
}
