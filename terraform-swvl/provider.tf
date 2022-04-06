provider "google" {
  credentials = "${file("~/Downloads/triple-voyage-278712-b28ad900530e.json")}"
  project = var.project
  region  = var.region
}
