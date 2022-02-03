variable "name" {
  type        = string
  description = "The name of the folder"
}

variable "parent" {
  type        = string
  description = "The parent of the folder"
}

variable "access" {
  type        = list(string)
  description = "A list of users that should be able to view this folder"
  default     = []
}
