resource "google_compute_instance" "swvl_bonus" {
  name         = "swvl-bonus"
  machine_type = "c2-standard-4"
  zone         = "${var.region}-a"
  tags         = ["externalssh","webserver"]
  boot_disk {
    initialize_params {
      size  = 20
      type  = "pd-ssd"
      image = "centos-cloud/centos-7"
    }
  

    }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static_swvl.address
    }
  }
  metadata = {
    ssh-keys = "${var.user}:${file(var.publickeypath)}"
  }
}
resource "google_compute_disk" "swvl" {
  project = var.project
  name    = "swvl-disk"
  type    = "pd-ssd"
  zone    = "${var.region}-a"
  size    = 100
  physical_block_size_bytes = 4096
}

resource "google_compute_attached_disk" "default" {
  disk     = google_compute_disk.swvl.id
  instance = google_compute_instance.swvl_bonus.id
}


