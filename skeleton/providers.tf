provider "google" {
  # Unfortunately this value needs to be hard-coded
  impersonate_service_account = "<unique id>-core@<unique-id>core.iam.gserviceaccount.com"
}
