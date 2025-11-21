variable "cluster_name" {
  description = "Name of the LKE cluster"
  type        = string
}

variable "k8s_version" {
  description = "Kubernetes version"
  type        = string
}

variable "linode_region" {
  description = "Linode region"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "node_type" {
  description = "Linode instance type"
  type        = string
}

variable "node_count" {
  description = "Number of worker nodes"
  type        = number
}
