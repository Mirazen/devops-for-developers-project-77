resource "random_password" "db_password" {
  length  = 16
  special = true
}

resource "yandex_mdb_postgresql_cluster" "db_cluster" {
  name        = "app-postgres-cluster"
  environment = "PRESTABLE"
  network_id  = yandex_vpc_network.app_network.id

  config {
    version = 15
    resources {
      resource_preset_id = "s2.micro"
      disk_type_id       = "network-hdd"
      disk_size          = 10
    }
  }

  host {
    zone      = "ru-central1-a"
    subnet_id = yandex_vpc_subnet.subnet_a.id
  }
}

resource "yandex_mdb_postgresql_database" "app_db" {
  cluster_id = yandex_mdb_postgresql_cluster.db_cluster.id
  name       = "appdb"
  owner      = yandex_mdb_postgresql_user.app_user.name
}

resource "yandex_mdb_postgresql_user" "app_user" {
  cluster_id = yandex_mdb_postgresql_cluster.db_cluster.id
  name       = "appuser"
  password   = random_password.db_password.result
}
