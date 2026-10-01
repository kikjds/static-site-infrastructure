resource "cloudflare_zone" "domain" {
  account = {
    id = var.CLOUDFLARE_ACCOUNT_ID
  }
  name = var.DOMAIN_NAME
  type = "full"
}