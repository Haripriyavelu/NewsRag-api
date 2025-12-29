# ============================================
# Terraform Outputs
# ============================================

output "existing_resource_group_name" {
  value = var.existing_resource_group_name
}

# ACR Outputs (Needed for CI/CD Login)
output "acr_login_server" {
  value = azurerm_container_registry.acr.login_server
}

output "acr_admin_username" {
  value = azurerm_container_registry.acr.admin_username
  sensitive = true
}

output "acr_admin_password" {
  value = azurerm_container_registry.acr.admin_password
  sensitive = true
}

output "acr_name" {
    value = azurerm_container_registry.acr.name
}

# Container App Names (Dynamic based on region)
output "container_app_names" {
  value = {
    for k, v in module.container_apps : k => v.container_app_name
  }
}

# Container App URLs (for easy access)
output "container_app_urls" {
  description = "URLs for all deployed container apps"
  value = {
    for k, v in module.container_apps : k => "https://${v.container_app_fqdn}"
  }
}

output "front_door_hostname" {
  value = length(module.front_door) > 0 ? module.front_door[0].frontdoor_endpoint_hostname : null
}

# Deployment Summary
output "deployment_summary" {
  description = "Summary of the deployment"
  value = {
    environment     = var.environment
    regions         = keys(local.regions)
    acr_name        = azurerm_container_registry.acr.name
    front_door_url  = length(module.front_door) > 0 ? "https://${module.front_door[0].frontdoor_endpoint_hostname}" : "N/A (dev)"
    container_apps  = { for k, v in module.container_apps : k => "https://${v.container_app_fqdn}" }
    monitoring      = var.environment == "prod" ? "enabled" : "disabled"
  }
}
