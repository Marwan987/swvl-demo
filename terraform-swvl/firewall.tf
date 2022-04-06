resource "google_compute_firewall" "swvl_ssh" {
  name    = "externalssh2"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["externalssh"]
}
resource "google_compute_firewall" "swvl_rule" {
  name    = "webserver2"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80","443","8080"]
  }
  source_ranges = ["0.0.0.0/0"] # Not So Secure. Limit the Source Range
  target_tags   = ["webserver"]
}