variable "linode_token" {
  description = "Linode API Token"
  type        = string
  sensitive   = true
}

variable "linode_region" {
  description = "Linode region for resources"
  type        = string
  default     = "us-east"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "cluster_name" {
  description = "Name of the LKE cluster"
  type        = string
  default     = "monitoring-cluster"
}

variable "k8s_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.27"
}

variable "node_type" {
  description = "Linode instance type for worker nodes"
  type        = string
  default     = "g6-standard-2"
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
  default     = 3
}

variable "prometheus_namespace" {
  description = "Kubernetes namespace for Prometheus"
  type        = string
  default     = "monitoring"
}

variable "grafana_namespace" {
  description = "Kubernetes namespace for Grafana"
  type        = string
  default     = "monitoring"
}

variable "grafana_admin_password" {
  description = "Admin password for Grafana"
  type        = string
  sensitive   = true
  default     = "admin123"
}
