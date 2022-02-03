variable "name" {
  type        = string
  description = "Name of the project"
}

variable "folder" {
  type        = string
  description = "Folder the project should appear in"
}

variable "billing" {
  type        = string
  description = "The billing account to use for the project"
}

variable "core" {
  type = object({
    project         = string
    service_account = string
    organization-id    = string
    administrators  = list(string)
    state           = object({
      domain   = string
      location = string
    })
    roles = object({
      viewer = string
    })
  })
  description = "Pass here the output of module.core"
}

variable "services" {
  type        = list(string)
  default     = []
  description = "A list of services to activate on the project"
}

variable "superusers" {
  type = object({
    names = list(string)
    roles = list(string)
  })

  default = {
    names = []
    roles = []
  }

  description = "A list of superusers that can impersonate the main project service account and possibly additional roles to be granted to the service account."
}

variable "users" {
  type = list(object({
    names = list(string)
    roles = list(string)
  }))

  default = []
  description = "A list of regular users and additional roles they have int he project"
}

variable "google-service-accounts" {
  type = list(object({
    name = string
    role = string
  }))

  default = []
  description = "A list of (auto-created by Google) service accounts needed by some services"
}

variable "service-accounts" {
  type = list(object({
    name        = string
    roles       = list(string)
    impersonate = list(string)
  }))

  default = []
  description = "A list of extra service accounts to create, their roles and who can impersonate them."
}
