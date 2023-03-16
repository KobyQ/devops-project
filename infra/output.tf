output "AZURE_COSMOS_CONNECTION_STRING_KEY" {
  value = local.cosmos_connection_string_key
}

output "AZURE_COSMOS_DATABASE_NAME" {
  value = module.cosmos.AZURE_COSMOS_DATABASE_NAME
}

output "AZURE_KEY_VAULT_ENDPOINT" {
  value     = module.keyvault.AZURE_KEY_VAULT_ENDPOINT
  sensitive = true
}

output "API_BASE_URL" {
  value = module.api.URI
}

output "AZURE_LOCATION" {
  value = var.location
}
