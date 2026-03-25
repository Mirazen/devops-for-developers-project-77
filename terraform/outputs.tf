output "web_servers_ips" {
  value       = yandex_compute_instance.app_server[*].network_interface.0.nat_ip_address
  description = "Public IPs of the web servers"
}

output "db_host" {
  value       = yandex_mdb_postgresql_cluster.db_cluster.host.0.fqdn
  description = "PostgreSQL cluster active host FQDN"
}

output "db_password" {
  value       = random_password.db_password.result
  sensitive   = true
  description = "Generated password for the PostgreSQL appuser"
}

output "load_balancer_ip" {
  value       = yandex_alb_load_balancer.app_lb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address
  description = "Public IP of the Application Load Balancer"
}

output "certificate_dns_challenge_name" {
  value       = yandex_cm_certificate.le_cert.challenges[0].dns_name
  description = "Name of the DNS CNAME record to create for Let's Encrypt validation"
}

output "certificate_dns_challenge_value" {
  value       = yandex_cm_certificate.le_cert.challenges[0].dns_value
  description = "Value for the DNS CNAME record to create for Let's Encrypt validation"
}
