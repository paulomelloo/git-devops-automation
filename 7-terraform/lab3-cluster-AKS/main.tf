# Configuração do provedor AzureRM e criação do cluster AKS
data "azurerm_kubernetes_cluster" "aks_data" {
  name                = azurerm_kubernetes_cluster.aks.name
  resource_group_name = azurerm_kubernetes_cluster.aks.resource_group_name
}

# Criar o resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Criar o cluster AKS
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.rg.location # usar a location do resource group
  resource_group_name = azurerm_resource_group.rg.name     # usar o nome do resource group criado
  dns_prefix          = "aksfree"                          # prefixo DNS para o cluster AKS

  default_node_pool {
    name       = "default"
    node_count = 2              # numero de nodes no cluster AKS, vai gerar custos
    vm_size    = "Standard_B2s" # ideal para camada gratuita do AKS
  }

  identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "Dev"
  }
}

# Criar um IP público para o Ingress Controller
resource "azurerm_public_ip" "ingress_pip" {
  name                = "myAKSPublicIPForIngress"
  location            = azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_kubernetes_cluster.aks_data.node_resource_group
  allocation_method   = "Static"
  sku                 = "Standard"
}