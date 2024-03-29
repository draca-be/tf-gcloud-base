resource "google_compute_shared_vpc_service_project" "network" {
  count           = length(var.subnets) == 0 ? 0 : 1
  host_project    = var.core.network
  service_project = google_project.project.project_id
}

resource "google_org_policy_policy" "network" {
  count = length(var.subnets) == 0 ? 0 : 1

  name   = "constraints/compute.restrictSharedVpcSubnetworks"
  parent = "projects/${google_project.project.name}"

  spec {
    rules {
      values {
        allowed_values = [
        for subnet in var.subnets : "projects/${var.core.network}/regions/${subnet.region}/subnetworks/${subnet.name}"
        ]
      }
    }
  }
}
