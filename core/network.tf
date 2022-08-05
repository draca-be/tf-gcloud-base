resource "google_organization_iam_member" "network-vpc-admin" {
  org_id = var.organization-id
  role   = "roles/compute.xpnAdmin"
  member = "serviceAccount:${module.project.service_account}"
}

# We won't use the default service account and storage bucket but leave it as has no cost. Potentially in the future
# network can be managed separately and we'll need it anyway.
module "network" {
  source = "../project"

  name    = local.network-name
  folder  = module.folder.name
  billing = var.billing

  core = local.core

  users = [
    {
      names = ["serviceAccount:${module.project.service_account}"]
      roles = [
        "roles/compute.securityAdmin"
      ]
    }
  ]
}

resource "google_compute_network" "network" {
  name                    = local.network-name
  project                 = module.network.project
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false
}

resource "google_compute_shared_vpc_host_project" "host" {
  project = module.network.project
}

resource "google_compute_subnetwork" "network" {
  count = length(var.subnets)

  name          = var.subnets[count.index].name
  region        = var.subnets[count.index].region
  ip_cidr_range = var.subnets[count.index].cidr

  network = google_compute_network.network.id
  project = module.network.project
}

# Allow ssh access through gcloud compute ssh using IAP
resource "google_compute_firewall" "ssh" {
  project = module.network.project
  name    = "allow-ssh"
  network = google_compute_network.network.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["35.235.240.0/20"]
}

# Allow pings from anywhere in our VPC network
resource "google_compute_firewall" "ping" {
  project = module.network.project
  name    = "allow-icmp"
  network = google_compute_network.network.id

  allow {
    protocol = "icmp"
  }
  source_ranges = ["10.0.0.0/8"]
}
