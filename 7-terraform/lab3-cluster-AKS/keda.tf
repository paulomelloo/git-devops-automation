# Configuração do namespace KEDA e instalação do KEDA via Helm
resource "kubernetes_namespace" "keda" {
  metadata {
    name = "keda"
  }
}

# Instalar o KEDA via Helm, usando o chart oficial do KEDA
resource "helm_release" "name" {
  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  namespace  = kubernetes_namespace.keda.metadata[0].name
  version    = "2.8.0"

  values = [
    <<EOF
replicaCount: 1
EOF
  ]

  depends_on = [kubernetes_namespace.keda]
}