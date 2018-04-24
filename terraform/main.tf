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

resource "google_compute_instance_template" "tf-server" {
  name = "tf-server"
  project = "comp698-dml1037"
  disk {
    source_image = "cos-cloud/cos-stable"
  }
  machine_type = "n1-standard-1"
  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["http-server"] 

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_write",
    ]
  }
  metadata {
      gce-container-declaration = <<EOF
  spec:
    containers:
    - image: 'gcr.io/comp698-dml1037/github-dml1037-my_web_server:8df295e7641bfb190ff365b22fc9b24d85066529'
      name: service-container
      stdin: false
      tty: false
    restartPolicy: Always
EOF
  }
}

resource "google_compute_instance_template" "tf-server2" {
  name = "tf-server2"
  project = "comp698-dml1037"
  disk {
    source_image = "cos-cloud/cos-stable"
  }
  machine_type = "n1-standard-1"
  network_interface {
    network = "default"
    access_config {}
  }

  tags = ["http-server"]

  service_account {
    scopes = [
      "https://www.googleapis.com/auth/compute",
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/devstorage.read_write",
    ]
  }
  metadata {
      gce-container-declaration = <<EOF
  spec:
    containers:
    - image: 'gcr.io/comp698-dml1037/github-dml1037-my_web_server:8df295e7641bfb190ff365b22fc9b24d85066529'
      name: service-container
      stdin: false
      tty: false
    restartPolicy: Always
EOF
  }
}

resource "google_compute_instance_group_manager" "default" {
  name = "tf-manager"
  project = "comp698-dml1037"
  zone = "us-central1-f"
  base_instance_name = "prod"
  instance_template  = "${google_compute_instance_template.tf-server.self_link}"
  target_size = 2
}

resource "google_compute_instance_group_manager" "default2" {
  name = "tf-manager2"
  project = "comp698-dml1037"
  zone = "us-central1-f"
  base_instance_name = "staging"
  instance_template  = "${google_compute_instance_template.tf-server2.self_link}"
  target_size = 1
}

resource "google_storage_bucket" "image-store" {
  project  = "comp698-dml1037"
  name     = "isunburntooeasily"
  location = "us-central1"
}
