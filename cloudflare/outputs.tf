output "cloudflare_name_servers" {
  description = "Cloudflare authoritative name servers to configure at the domain registrar."
  value       = cloudflare_zone.domain.name_servers
}