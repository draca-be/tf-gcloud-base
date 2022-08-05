module "core" {
  source = "../gcloud-base/core"

  organization-id = "<numerical google organization id>"
  unique-id       = "example"
  administrators      = local.administrators
  billing         = local.billing.default
  state           = {
    domain   = "example.com"
    location = "EUROPE-WEST1"
  }
}
