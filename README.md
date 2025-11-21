# MSIGrid - Kubernetes Monitoring Stack on Linode

A production-ready Infrastructure as Code (IaC) project that deploys a comprehensive monitoring solution on Linode Kubernetes Engine (LKE) using Terraform, Prometheus, Grafana, and AlertManager.

## 📋 Project Overview

This project automates the deployment of a complete observability stack on Linode's managed Kubernetes service. It provides real-time metrics collection, visualization dashboards, and alerting capabilities for monitoring containerized applications and infrastructure.

**Key Features:**
- Automated LKE cluster provisioning
- Production-grade monitoring with Prometheus
- Beautiful dashboards with Grafana
- Alert management with AlertManager
- Persistent storage for metrics and dashboards
- Load-balanced access to services via Linode NodeBalancers

## 🏗️ Architecture

```
monitoring-stack/
├── main.tf                     # Root module orchestration
├── providers.tf                # Provider configurations
├── variables.tf                # Input variables
├── outputs.tf                  # Output values
├── terraform.tfvars            # Variable values
├── backend.tf                  # State backend configuration
├── lke/
│   ├── lke-cluster.tf          # Linode Kubernetes cluster
│   ├── variables.tf            # LKE module variables
│   └── versions.tf             # Provider requirements
├── helm/
│   ├── prometheus.tf           # Prometheus stack deployment
│   ├── grafana.tf              # Grafana deployment
│   └── variables.tf            # Helm module variables
├── dashboards/
│   └── custom-dashboard.json   # Custom Grafana dashboards
└── alert-rules/
    └── custom-alert-rules.yaml # Prometheus alert rules
```

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [kubectl](https://kubernetes.io/docs/tasks/tools/) (for cluster access)
- A [Linode account](https://www.linode.com/) with API access
- Linode API Token ([create one here](https://cloud.linode.com/profile/tokens))

### 1. Configure Variables

Edit `monitoring-stack/terraform.tfvars`:

```hcl
linode_token = "YOUR_LINODE_API_TOKEN"  # Replace with your actual token
linode_region = "us-east"               # Choose your region

environment = "dev"
cluster_name = "monitoring-cluster"
k8s_version  = "1.27"
node_type    = "g6-standard-2"          # 2 CPU, 4GB RAM
node_count   = 3

prometheus_namespace   = "monitoring"
grafana_namespace      = "monitoring"
grafana_admin_password = "YourSecurePassword123!"
```

### 2. Initialize Terraform

```bash
cd monitoring-stack
terraform init
```

### 3. Review the Plan

```bash
terraform plan
```

### 4. Deploy the Infrastructure

```bash
terraform apply
```

Type `yes` when prompted to confirm the deployment.

### 5. Access Your Services

After deployment completes (5-10 minutes), get the service endpoints:

```bash
# Get the kubeconfig
terraform output -raw kubeconfig > kubeconfig.yaml
export KUBECONFIG=./kubeconfig.yaml

# Check service status
kubectl get svc -n monitoring

# Get external IPs for services
kubectl get svc -n monitoring prometheus-kube-prometheus-prometheus
kubectl get svc -n monitoring grafana
kubectl get svc -n monitoring prometheus-kube-prometheus-alertmanager
```

**Access Grafana:**
- URL: `http://<GRAFANA_EXTERNAL_IP>`
- Username: `admin`
- Password: (value from `grafana_admin_password` in terraform.tfvars)

## 🛠️ Technologies Used

### Infrastructure & Orchestration
- **Terraform** - Infrastructure as Code tool for provisioning cloud resources
- **Linode Cloud** - Cloud hosting platform providing LKE (Linode Kubernetes Engine)
- **Kubernetes** - Container orchestration platform
- **Helm** - Kubernetes package manager for deploying applications

### Monitoring & Observability
- **Prometheus** - Time-series database and monitoring system
- **Grafana** - Visualization and analytics platform
- **AlertManager** - Alert handling and routing
- **kube-state-metrics** - Kubernetes cluster state metrics
- **node-exporter** - Hardware and OS metrics

### Storage & Networking
- **Linode Block Storage** - Persistent volumes for metrics and dashboards
- **Linode NodeBalancers** - Load balancers for external service access

## 📚 What I Learned

### Cloud Migration
- **Multi-cloud strategy**: Migrated from AWS EKS to Linode LKE, understanding the differences between cloud providers
- **Provider abstraction**: Learned how Kubernetes provides a consistent API across different cloud platforms
- **Storage classes**: Adapted from AWS EBS (`gp2`) to Linode Block Storage

### Infrastructure as Code
- **Terraform modules**: Structured code into reusable modules (`lke`, `helm`)
- **Provider configuration**: Dynamically configured Kubernetes and Helm providers using kubeconfig
- **State management**: Implemented local state backend for development

### Kubernetes & Helm
- **Helm charts**: Deployed complex applications using `kube-prometheus-stack` and `grafana` charts
- **Service types**: Configured LoadBalancer services for external access
- **Persistent storage**: Set up PersistentVolumeClaims for stateful workloads
- **Namespaces**: Organized resources using Kubernetes namespaces

### Monitoring Best Practices
- **Metrics retention**: Configured 15-day retention for Prometheus metrics
- **Resource limits**: Set CPU and memory limits for all components
- **Dashboard provisioning**: Automated Grafana dashboard deployment
- **Alert rules**: Implemented custom alerting for cluster health

### DevOps & Automation
- **Declarative configuration**: Defined entire infrastructure in code
- **Idempotency**: Ensured Terraform can be run multiple times safely
- **Output values**: Exposed important information (kubeconfig, endpoints) via Terraform outputs

## 🔧 Customization

### Scaling the Cluster

Edit `terraform.tfvars`:
```hcl
node_count = 5  # Increase worker nodes
node_type = "g6-standard-4"  # Use larger instances (4 CPU, 8GB RAM)
```

### Changing Regions

Available Linode regions: `us-east`, `us-west`, `eu-central`, `ap-south`, etc.

```hcl
linode_region = "eu-central"
```

### Adding Custom Dashboards

1. Export your dashboard JSON from Grafana
2. Place it in `dashboards/` directory
3. Update `helm/grafana.tf` to include it

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

Type `yes` when prompted. This will delete the LKE cluster, NodeBalancers, and all associated resources.

## 📝 License

This project is open source and available under the MIT License.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome!

---

**Built with ❤️ using Terraform and Linode**
