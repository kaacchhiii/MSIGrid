resource "linode_lke_cluster" "main" {
  label       = var.cluster_name
  k8s_version = var.k8s_version
  region      = var.linode_region
  tags        = [var.environment]

  pool {
    type  = var.node_type
    count = var.node_count
  }
}

output "kubeconfig" {
  value     = linode_lke_cluster.main.kubeconfig
  sensitive = true
}

output "api_endpoints" {
  value = linode_lke_cluster.main.api_endpoints
}

output "status" {
  value = linode_lke_cluster.main.status
}

output "id" {
  value = linode_lke_cluster.main.id
}

output "pool_id" {
  value = linode_lke_cluster.main.pool[0].id
}
