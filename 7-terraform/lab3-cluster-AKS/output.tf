# Output.tf - Outputs do Terraform para o Lab3 - Cluster AKS com Ingress Controller
output "next_steps" {
  value = <<EOT
    Cluster AKS criado com sucesso!

    Para acessar o cluster AKS, siga os passos abaixo:
    az aks get-credentials --resource-group ${var.resource_group_name} --name ${var.aks_cluster_name}

    Ingress Controller instalado com sucesso!

    Acess o IP fixo criado:
    http://${azurerm_public_ip.ingress_pip.ip_address}

    Você vera uma mensagem "404 Not Found" do NGINX, isso significa que o Ingress Controller está funcionando corretamente.

    - Prossiga para o Lab3 para criar uma aplicação + Ingress Resource.

    EOT  
}

# output do nome do resource group
output "resource_group_name" {
  value = var.resource_group_name
}

# output do nome do cluster AKS
output "aks_cluster_name" {
  value = var.aks_cluster_name
}