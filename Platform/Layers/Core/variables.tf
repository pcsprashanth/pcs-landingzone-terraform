variable "root_id" {
  type    = string
  default = "mg-itaudev"
}

variable "root_name" {
  type    = string
  default = "Itaudev"
}

variable "mg_id" {
  type    = string
  default = "ManagementGroups/mg-itaudev-sandbox"
}

variable "mi_name" {
  type    = string
  default = "itau_managed_identity"
}

variable "mi_rg_name" {
  type    = string
  default = "ITAUTEST"
}

variable "workspace_id" {
  type = string
  default = "ea2f629a-716d-4aba-b660-6ae840d23c52"
}

variable "reader_access_id" {
  type = list
  default = ["cfdaf25b-a360-4eb4-b319-101433ecabcb", "1d5f2329-31b0-4373-b5a3-709e5014d4ea"]
}



