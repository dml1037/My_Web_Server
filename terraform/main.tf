terraform {
 backend "gcs" {
   project = "comp698-dml1037"
   bucket  = "comp698-dml1037-terraform-state"
   prefix  = "terraform-state"
 }
}
provider "google" {

  project = "comp698-dml1037"
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
    access_config {
    }
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

  tags = ["http-server"]
}

resource "google_compute_instance_group_manager" "default" {
  name = "tf-my-web-server-manager"
  project = "comp698-dml1037"
  zone = "us-central1-f"
  base_instance_name = "app"
  instance_template  = "${google_compute_instance_template.tf-my-web-server.self_link}"
  target_size = 2

}

resource "google_storage_bucket" "image-store" {
  project  = "comp698-dml1037"
  name     = "isunburntooeasily"
  location = "us-central1"
}
