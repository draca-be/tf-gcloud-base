output "project" {
  value = module.project.project
}

output "service_account" {
  value = module.project.service_account
}

output "organization-id" {
  value = var.organization-id
}

output "administrators" {
  value = var.administrators
}

output "state" {
  value = var.state
}

output "roles" {
  value = local.roles
}

output "folder" {
  value = module.folder.name
}

output "network" {
  value = module.network.project
}
