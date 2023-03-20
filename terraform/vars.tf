# zona azure
variable "location" {
  type = string
  description = "Region"
  default = "West Europe"
}
# key publica creada para anadirlo a la maquina virtual
variable "ssh_public_key" {
  default = "~/.ssh/az_vm_unir.pub"
}

# maquina virtual a crear
variable "vms" {
  description = "Maquinas Virtuales a crear"
  default = ["webserver"]  
}
# sabor mv
variable "vms_flavors_id" {
  description = "Sabores a aplicar"
  type        = list(string)
  default     = ["Standard_B1ms"]
  # B1ms 1vcpu 2 gb mem
}

# Creacion de cluster AKS

# Recomendado 3 nodos pero se seleccionan 2 por la limitacion de cpu
variable "agent_count" {
  default = 2
}

# The following two variable declarations are placeholder references.
# Set the values for these variable in terraform.tfvars
variable "aks_service_principal_app_id" {
  default = ""
}

variable "aks_service_principal_client_secret" {
  default = ""
}
# nombre del cluster
variable "cluster_name" {
  default = "UNIRp2AKS"
}
# prefijo para dns
variable "dns_prefix" {
  default = "UNIRp2AKS"
}

# Refer to https://azure.microsoft.com/global-infrastructure/services/?products=monitor for available Log Analytics regions.
# log analytics
variable "log_analytics_workspace_location" {
  default = "westeurope"
}
# log analytics
variable "log_analytics_workspace_name" {
  default = "testLogAnalyticsWorkspaceName"
}

# en https://azure.microsoft.com/pricing/details/monitor/ vienen precios
variable "log_analytics_workspace_sku" {
  default = "PerGB2018"
}
# localizacion del grupo de recursos
variable "resource_group_location" {
  default     = "westeurope"
  description = "Location of the resource group."
}
# prefijo para el grupo de recursos
variable "resource_group_name_prefix" {
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

