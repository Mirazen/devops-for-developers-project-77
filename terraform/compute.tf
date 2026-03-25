data "yandex_compute_image" "ubuntu" {
  family = "ubuntu-2204-lts"
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem
  filename        = "${path.module}/../ansible/id_rsa"
  file_permission = "0600"
}

resource "yandex_compute_instance" "app_server" {
  count = 2

  name        = "app-server-${count.index + 1}"
  platform_id = "standard-v3"
  zone        = count.index == 0 ? "ru-central1-a" : "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = count.index == 0 ? yandex_vpc_subnet.subnet_a.id : yandex_vpc_subnet.subnet_b.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${tls_private_key.ssh_key.public_key_openssh}"
  }
}
