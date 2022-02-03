module "folder" {
  source = "../folder"

  name   = var.folder
  parent = "organizations/${var.organization-id}"

  access = var.administrators
}
