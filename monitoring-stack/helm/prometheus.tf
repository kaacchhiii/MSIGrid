resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.prometheus_namespace
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "51.2.0"

  values = [
    yamlencode({
      prometheus = {
        prometheusSpec = {
          storageSpec = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "linode-block-storage-retain"
                accessModes      = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = "50Gi"
                  }
                }
              }
            }
          }
          retention = "15d"
          resources = {
            limits = {
              cpu    = "2000m"
              memory = "8Gi"
            }
            requests = {
              cpu    = "1000m"
              memory = "4Gi"
            }
          }
        }
        service = {
          type = "LoadBalancer"
        }
      }

      alertmanager = {
        alertmanagerSpec = {
          storage = {
            volumeClaimTemplate = {
              spec = {
                storageClassName = "linode-block-storage-retain"
                accessModes      = ["ReadWriteOnce"]
                resources = {
                  requests = {
                    storage = "10Gi"
                  }
                }
              }
            }
          }
          resources = {
            limits = {
              cpu    = "100m"
              memory = "128Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
        service = {
          type = "LoadBalancer"
        }
      }

      grafana = {
        enabled = false
      }

      nodeExporter = {
        enabled = true
      }

      kubeStateMetrics = {
        enabled = true
      }

      prometheusOperator = {
        enabled = true
        resources = {
          limits = {
            cpu    = "200m"
            memory = "200Mi"
          }
          requests = {
            cpu    = "100m"
            memory = "100Mi"
          }
        }
      }
    })
  ]

  depends_on = [kubernetes_namespace.monitoring]

  timeout = 600
}

output "prometheus_service_name" {
  description = "Name of the Prometheus service"
  value       = "${helm_release.prometheus.name}-kube-prometheus-prometheus"
}

output "prometheus_service_url" {
  description = "URL for Prometheus service"
  value       = "http://${helm_release.prometheus.name}-kube-prometheus-prometheus.${kubernetes_namespace.monitoring.metadata[0].name}.svc.cluster.local:9090"
}

output "alertmanager_service_name" {
  description = "Name of the Alertmanager service"
  value       = "${helm_release.prometheus.name}-kube-prometheus-alertmanager"
}

output "prometheus_operator_service_name" {
  description = "Name of the Prometheus Operator service"
  value       = "${helm_release.prometheus.name}-kube-prometheus-operator"
}
