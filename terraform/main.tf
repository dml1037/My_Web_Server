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

//manager
resource "google_compute_instance_template" "instance_template" {
  name_prefix  = "instance-template-"
  machine_type = "n1-standard-1"
  region       = "us-central1"
  project = "comp698-dml1037"

  // boot disk
  disk {
    # ...
  }

  // networking
  network_interface {
    # ...
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = "instance-group-manager"
  instance_template  = "${google_compute_instance_template.instance_template.self_link}"
  base_instance_name = "instance-group-manager"
  zone               = "us-central1-f"
  target_size        = "1"
}
