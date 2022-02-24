resource "google_org_policy_policy" "default-network" {
  name   = "organizations/${var.organization-id}/policies/compute.skipDefaultNetworkCreation"
  parent = "organizations/${var.organization-id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

resource "google_org_policy_policy" "default-service-accounts-iam" {
  name   = "organizations/${var.organization-id}/policies/iam.automaticIamGrantsForDefaultServiceAccounts"
  parent = "organizations/${var.organization-id}"

  spec {
    rules {
      enforce = "TRUE"
    }
  }
}

# On organization level we do not set policy or use bindings as we could lock ourselves out.
# Manual cleanup might be required.
resource "google_organization_iam_member" "billing" {
  org_id = var.organization-id
  role   = "roles/billing.user"
  member = "serviceAccount:${module.project.service_account}"
}

resource "google_organization_iam_member" "folder" {
  org_id = var.organization-id
  role   = "roles/resourcemanager.folderAdmin"
  member = "serviceAccount:${module.project.service_account}"
}

resource "google_organization_iam_member" "organization" {
  org_id = var.organization-id
  role   = "roles/resourcemanager.organizationAdmin"
  member = "serviceAccount:${module.project.service_account}"
}

resource "google_organization_iam_member" "policy" {
  org_id = var.organization-id
  role   = "roles/orgpolicy.policyAdmin"
  member = "serviceAccount:${module.project.service_account}"
}

resource "google_organization_iam_member" "project-creator" {
  org_id = var.organization-id
  role   = "roles/resourcemanager.projectCreator"
  member = "serviceAccount:${module.project.service_account}"
}

resource "google_organization_iam_member" "project-mover" {
  org_id = var.organization-id
  role   = "roles/resourcemanager.projectMover"
  member = "serviceAccount:${module.project.service_account}"
}

resource "google_organization_iam_member" "roles" {
  org_id = var.organization-id
  role   = "roles/iam.organizationRoleAdmin"
  member = "serviceAccount:${module.project.service_account}"
}

resource "null_resource" "bootstrap" {
  depends_on = [
    google_organization_iam_member.roles,
    google_organization_iam_member.project-mover,
    google_organization_iam_member.project-creator,
    google_organization_iam_member.policy,
    google_organization_iam_member.organization,
    google_organization_iam_member.folder,
    google_organization_iam_member.billing,
  ]
}
