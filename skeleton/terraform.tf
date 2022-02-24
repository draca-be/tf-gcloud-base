terraform {
  backend "gcs" {
    # Unfortunately we have to hardcode these values, we can't calculate them.
    bucket                      = "tf-<unique-id>-core.<configured domain>"
    prefix                      = "terraform/"
    impersonate_service_account = "<unique-id>-core@<unique-id>-core.iam.gserviceaccount.com"
  }
}
