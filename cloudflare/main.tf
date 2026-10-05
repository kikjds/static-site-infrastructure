resource "cloudflare_zone" "domain" {
  account = {
    id = var.CLOUDFLARE_ACCOUNT_ID
  }

  name = var.DOMAIN_NAME
  type = "full"
}

resource "cloudflare_dns_record" "root_a" {
  zone_id = cloudflare_zone.domain.id
  name    = "@"
  content = var.SERVER_ADDRESS
  type    = "A"
  ttl     = 3600
}