terraform {
  required_providers {
    azurerm = {
      version = "~>3.18.0"
      source  = "hashicorp/azurerm"
    }
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "~>1.2.15"
    }
  }
}
# ------------------------------------------------------------------------------------------------------
# Deploy network
# ------------------------------------------------------------------------------------------------------
resource "azurerm_virtual_network" "devops_vnet" {
  name                = "devops_vnet"
  resource_group_name = var.rg_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "integration_subnet" {
  name                 = "integration_subnet"
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.devops_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "delegation"
    service_delegation {
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet" "endpoint_subnet" {
  name                                           = "endpoint_subnet"
  resource_group_name                            = var.rg_name
  virtual_network_name                           = azurerm_virtual_network.devops_vnet.name
  address_prefixes                               = ["10.0.2.0/24"]
  private_endpoint_network_policies_enabled      = true
}

# virtual network integration gives the api access to resources in the virtual network that don't have a public endpoint. 
resource "azurerm_app_service_virtual_network_swift_connection" "vnetintegrationconnection" {
  app_service_id  = var.app_id
  subnet_id       = azurerm_subnet.integration_subnet.id
}

resource "azurerm_private_dns_zone" "devops_dns" {
  name                = "privatelink.cosmos.azure.com"
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns_zone_link" {
  name                  = "dns_zone_link"
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.devops_dns.name
  virtual_network_id    = azurerm_virtual_network.devops_vnet.id
}

# sets up a private endpoint for the database
resource "azurerm_private_endpoint" "devops_private_endpoint" {
  name                = "devops_private_endpoint"
  resource_group_name = var.rg_name
  location            = var.location
  subnet_id           = azurerm_subnet.endpoint_subnet.id

  private_dns_zone_group {
    name = "privatednszonegroup"
    private_dns_zone_ids = [azurerm_private_dns_zone.devops_dns.id]
  }

  private_service_connection {
    is_manual_connection       = false
    name                       = "privateendpointconnection"
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names          = ["MongoDB"]
  }
}