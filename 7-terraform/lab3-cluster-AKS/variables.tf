# Variavel para o resource group
variable "resource_group_name" {
  default = "rg-cluster-aks"
}

# Variavel para a location
variable "location" {
  default = "East US"
}

# Variavel para o nome do cluster AKS
variable "aks_cluster_name" {
  default = "aks-free-tier"
}