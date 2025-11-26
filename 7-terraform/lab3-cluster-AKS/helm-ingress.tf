# Criar um IP Público Estático para o Ingress Controller e instalar o Ingress Controller NGINX via Helm
resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress-nginx"
  }
}

# Intalar o Ingress Controller via Helm, usando o chart oficial do NGINX Ingress, configurando o IP fixo criado anteriormente.
resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = kubernetes_namespace.ingress.metadata[0].name
  version    = "4.7.0"
  values = [
    <<EOF
controller:
    replicaCount: 2
    nodeSelector:
      "kubernetes.io/os": "linux"
    service:
        loadBalancerIP: "${azurerm_public_ip.ingress_pip.ip_address}"
        type: LoadBalancer
        externalTrafficPolicy: Local

defaultBackend:
    nodeSelector:
      "kubernetes.io/os": "linux"
EOF
  ]

  depends_on = [azurerm_public_ip.ingress_pip]
}