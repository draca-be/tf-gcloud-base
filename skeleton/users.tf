locals {
  users = {
    superuser = "user:admin@example.com"
    regular = "user:regular@example.com"
  }

  administrators = [
    local.users.superuser,
    local.users.regular,
  ]
}
