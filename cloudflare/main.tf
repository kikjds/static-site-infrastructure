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
  content = var.IPV4_SERVER_ADDRESS
  type    = "A"
  ttl     = 1
  proxied = true
}

resource "cloudflare_dns_record" "root_aaa" {
  zone_id = cloudflare_zone.domain.id
  name    = "@"
  content = var.IPV6_SERVER_ADDRESS
  type    = "AAAA"
  ttl     = 1
  proxied = true
}

resource "tls_private_key" "origin" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "origin" {
  private_key_pem = tls_private_key.origin.private_key_pem

  subject {
    common_name = var.DOMAIN_NAME
  }
}

resource "cloudflare_origin_ca_certificate" "origin" {
  csr                = tls_cert_request.origin.cert_request_pem
  hostnames          = [var.DOMAIN_NAME, "*.${var.DOMAIN_NAME}"]
  request_type       = "origin-rsa"
  requested_validity = 5475
}

resource "cloudflare_zone_setting" "ssl" {
  zone_id    = cloudflare_zone.domain.id
  setting_id = "ssl"
  value      = "strict"
} 