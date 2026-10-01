variable "CLOUDFLARE_API_TOKEN" {
  type        = string
  description = "Cloudflare API token"
  sensitive   = true
}

variable "CLOUDFLARE_ACCOUNT_ID" {
  type        = string
  description = "Cloudflare account id"
}

variable "DOMAIN_NAME" {
  type        = string
  description = "Name of domain"
}