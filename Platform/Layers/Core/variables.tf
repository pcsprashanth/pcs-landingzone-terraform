variable "root_id" {
  type    = string
  default = "mg-itaudev"
}

variable "root_name" {
  type    = string
  default = "Itaudev"
}

variable "archetype_id" {
  type        = string
  description = "Specifies the ID of the archetype to apply against the provided scope. Must be a valid archetype ID from either the built-in module library, or as defined by the library_path variable."
}