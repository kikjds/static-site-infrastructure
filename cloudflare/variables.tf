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

variable "IPV4_SERVER_ADDRESS" {
  type        = string
  description = "Origin server ipv4 address"
}

variable "IPV6_SERVER_ADDRESS" {
  type        = string
  description = "Origin server ipv6 address"
}