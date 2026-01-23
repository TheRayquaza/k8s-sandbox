variable "vault_address" {
  description = "Vault server address"
  type        = string
  default     = "http://localhost:8200"
}

variable "vault_root_token" {
  description = "Vault root token"
  type        = string
  sensitive   = true
}


# Cloudflare variables
variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_email" {
  type      = string
  sensitive = true
}
