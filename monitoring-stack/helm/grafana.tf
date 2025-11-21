resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "6.58.9"

  values = [
    yamlencode({
      adminPassword = var.grafana_admin_password

      persistence = {
        enabled          = true
        storageClassName = "linode-block-storage-retain"
        size             = "10Gi"
      }

      resources = {
        limits = {
          cpu    = "200m"
          memory = "256Mi"
        }
        requests = {
          cpu    = "100m"
          memory = "128Mi"
        }
      }

      service = {
        type = "LoadBalancer"
        port = 80
      }

      ingress = {
        enabled = false
      }

      datasources = {
        "datasources.yaml" = {
          apiVersion = 1
          datasources = [
            {
              name      = "Prometheus"
              type      = "prometheus"
              url       = "http://prometheus-kube-prometheus-prometheus.monitoring.svc.cluster.local:9090"
              access    = "proxy"
              isDefault = true
            }
          ]
        }
      }

      dashboardProviders = {
        "dashboardproviders.yaml" = {
          apiVersion = 1
          providers = [
            {
              name   = "default"
              orgId  = 1
              folder = ""
              type   = "file"
              options = {
                path = "/var/lib/grafana/dashboards/default"
              }
            }
          ]
        }
      }

      dashboards = {
        default = {
          "kubernetes-cluster-monitoring" = {
            gnetId     = 7249
            revision   = 1
            datasource = "Prometheus"
          }
          "kubernetes-pod-monitoring" = {
            gnetId     = 6417
            revision   = 1
            datasource = "Prometheus"
          }
          "node-exporter-full" = {
            gnetId     = 1860
            revision   = 27
            datasource = "Prometheus"
          }
        }
      }

      env = {
        GF_SECURITY_ADMIN_PASSWORD = var.grafana_admin_password
        GF_USERS_ALLOW_SIGN_UP     = false
      }

      rbac = {
        create     = true
        pspEnabled = false
      }

      serviceAccount = {
        create = true
        name   = "grafana"
      }

      securityContext = {
        runAsUser  = 472
        runAsGroup = 472
        fsGroup    = 472
      }

      podSecurityContext = {
        runAsUser  = 472
        runAsGroup = 472
        fsGroup    = 472
      }
    })
  ]

  depends_on = [
    kubernetes_namespace.monitoring,
    helm_release.prometheus
  ]

  timeout = 300
}

resource "kubernetes_config_map" "custom_dashboard" {
  metadata {
    name      = "custom-dashboard"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    labels = {
      grafana_dashboard = "1"
    }
  }

  data = {
    "custom-dashboard.json" = file("${path.module}/../dashboards/custom-dashboard.json")
  }

  depends_on = [kubernetes_namespace.monitoring]
}


output "grafana_service_name" {
  description = "Name of the Grafana service"
  value       = helm_release.grafana.name
}

output "grafana_service_url" {
  description = "URL for Grafana service"
  value       = "http://${helm_release.grafana.name}.${kubernetes_namespace.monitoring.metadata[0].name}.svc.cluster.local"
}

output "grafana_admin_user" {
  description = "Grafana admin username"
  value       = "admin"
}

output "grafana_namespace" {
  description = "Grafana namespace"
  value       = kubernetes_namespace.monitoring.metadata[0].name
}
