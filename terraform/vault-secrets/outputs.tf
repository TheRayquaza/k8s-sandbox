output "vault_mount_path" {
  value       = vault_mount.kv.path
  description = "The path where the KV secrets engine is mounted"
}

output "secrets_created" {
  value = {
    infrastructure = [
      vault_kv_secret_v2.cloudflare.name,
    ]
  }
  description = "List of all secrets created in Vault"
}
