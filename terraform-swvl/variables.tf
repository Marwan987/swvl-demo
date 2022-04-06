variable "region" {
    type = string
    default = "us-west4"
}
variable "zones" {
  type        = list(string)
  description = "The zones to create the cluster."
}


variable "project" {
    type = string
    default = "triple-voyage-278712"
}
variable "user" {
    type = string
    default = "marwan"
}
variable "email" {
    type = string
    default = "marwan@triple-voyage-278712.iam.gserviceaccount.com"
}
variable "privatekeypath" {
    type = string
    default = "~/.ssh/id_rsa"
}
variable "publickeypath" {
    type = string
    default = "~/.ssh/id_rsa.pub"
}

variable "machine_type" {
  type        = string
  description = "Type of the node compute engines."
}




variable "service_account" {
  type        = string
  description = "The service account to run nodes as if not overridden in `node_pools`. The create_service_account variable default value (true) will cause a cluster-specific service account to be created."
  default = "marwan@triple-voyage-278712.iam.gserviceaccount.com"
}

