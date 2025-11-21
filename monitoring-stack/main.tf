terraform {
  required_version = ">= 1.0"
}

module "lke" {
  source = "./lke"

  cluster_name  = var.cluster_name
  k8s_version   = var.k8s_version
  linode_region = var.linode_region
  environment   = var.environment
  node_type     = var.node_type
  node_count    = var.node_count
}

module "helm" {
  source = "./helm"

  prometheus_namespace   = var.prometheus_namespace
  grafana_namespace      = var.grafana_namespace
  grafana_admin_password = var.grafana_admin_password
  depends_on             = [module.lke]
}
