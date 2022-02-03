variable "organization-id" {
  type        = string
  description = "Your Google Cloud organization id"
}

variable "unique-id" {
  type        = string
  description = "A unique identifier for your setup, mostly used to generate names. Keep it short, lowercase and alphanumerical"
}

variable "folder" {
  type        = string
  description = "The name of the folder where the core projects will be created. This will be created directly under the organization. (default: core)"
  default     = "core"
}

variable "name" {
  type        = string
  description = "The name of the core project. (default: $${var.unique-id}-core)"
  default     = null
}

variable "billing" {
  type        = string
  description = "The billing account to be set on the project."
}

variable "administrators" {
  type        = list(string)
  description = "A list of users that will get permissions to manage and view all managed infrastructure"
}

variable "state" {
  type = object({
    domain   = string
    location = string
  })
  description = "The location where to store the state bucket and the domain suffix to use for the name"
}
