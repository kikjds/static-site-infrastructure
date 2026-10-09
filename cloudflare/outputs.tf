output "cloudflare_name_servers" {
  description = "Cloudflare authoritative name servers to configure at the domain registrar."
  value       = cloudflare_zone.domain.name_servers
}

output "origin_certificate_pem" {
  value     = cloudflare_origin_ca_certificate.origin.certificate
  sensitive = true
}

output "origin_private_key_pem" {
  value     = tls.tls_private_key.origin.private_key_pem
  sensitive = true
}