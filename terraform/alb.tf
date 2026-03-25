resource "yandex_cm_certificate" "le_cert" {
  name    = "le-cert"
  domains = ["danya-hexlet-devops.ru"]

  managed {
    challenge_type = "DNS_CNAME"
  }
}

resource "yandex_alb_target_group" "app_tg" {
  name = "app-target-group"

  dynamic "target" {
    for_each = yandex_compute_instance.app_server
    content {
      subnet_id  = target.value.network_interface.0.subnet_id
      ip_address = target.value.network_interface.0.ip_address
    }
  }
}

resource "yandex_alb_backend_group" "app_bg" {
  name = "app-backend-group"

  http_backend {
    name             = "http-backend"
    weight           = 1
    port             = 80
    target_group_ids = [yandex_alb_target_group.app_tg.id]

    load_balancing_config {
      panic_threshold = 90
    }

    healthcheck {
      timeout              = "10s"
      interval             = "2s"
      healthy_threshold    = 10
      unhealthy_threshold  = 15
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "app_router" {
  name = "app-http-router"
}

resource "yandex_alb_virtual_host" "app_vhost" {
  name           = "app-virtual-host"
  http_router_id = yandex_alb_http_router.app_router.id
  authority      = ["danya-hexlet-devops.ru"]

  route {
    name = "main-route"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.app_bg.id
        timeout          = "3s"
      }
    }
  }
}

resource "yandex_alb_load_balancer" "app_lb" {
  name       = "app-load-balancer"
  network_id = yandex_vpc_network.app_network.id

  allocation_policy {
    location {
      zone_id   = "ru-central1-a"
      subnet_id = yandex_vpc_subnet.subnet_a.id
    }
    location {
      zone_id   = "ru-central1-b"
      subnet_id = yandex_vpc_subnet.subnet_b.id
    }
  }

  listener {
    name = "http-redirect"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [80]
    }
    http {
      redirects {
        http_to_https = true
      }
    }
  }

  listener {
    name = "https-listener"
    endpoint {
      address {
        external_ipv4_address {}
      }
      ports = [443]
    }
    tls {
      default_handler {
        http_handler {
          http_router_id = yandex_alb_http_router.app_router.id
        }
        certificate_ids = [yandex_cm_certificate.le_cert.id]
      }
    }
  }
}
