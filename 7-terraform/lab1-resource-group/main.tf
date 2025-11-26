# configurar o resource group do AzureRM
resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-automation"
  location = "East US"
}