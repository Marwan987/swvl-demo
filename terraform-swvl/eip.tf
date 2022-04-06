resource "google_compute_address" "static_swvl" {
  name = "static-swvl"
  project = var.project
  region = "us-west4"
}