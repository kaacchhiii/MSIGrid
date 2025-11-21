output "kubeconfig" {
  description = "Kubeconfig for the LKE cluster"
  value       = module.lke.kubeconfig
  sensitive   = true
}

output "api_endpoints" {
  description = "API endpoints for the LKE cluster"
  value       = module.lke.api_endpoints
}

output "cluster_status" {
  description = "Status of the LKE cluster"
  value       = module.lke.status
}

output "pool_id" {
  description = "ID of the node pool"
  value       = module.lke.pool_id
}

output "prometheus_service_url" {
  description = "URL for Prometheus service"
  value       = module.helm.prometheus_service_url
}

output "grafana_service_url" {
  description = "URL for Grafana service"
  value       = module.helm.grafana_service_url
}
