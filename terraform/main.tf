terraform {
 backend "gcs" {
   project = "comp698-dml1037"
   bucket  = "comp698-dml1037-terraform-state"
   prefix  = "terraform-state"
 }
}
provider "google" {
  region = "us-central1"
}

resource "google_compute_instance_template" "tf-my-web-server" {
  name = "tf-my-web-server"
  project = "comp698-dml1037"
  disk {
    source_image = "cos-cloud/cos-stable"
  }
  machine_type = "n1-standard-1"
  network_interface {
    network = "default"
  }
}

resource "google_compute_instance_group_manager" "default" {
  name = "tf-manager"
  project = "comp698-dml1037"
  zone = "us-central1-f"
  base_instance_name = "app"
  instance_template  = "${google_compute_instance_template.tf-my-web-server.self_link}"
  target_size = 2

}

resource "google_storage_bucket" "image-store" {
  project  = "comp698-dml1037"
  name     = "danielleweb"
  location = "us-central1"
}