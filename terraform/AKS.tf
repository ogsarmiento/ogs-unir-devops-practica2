# Recursos para AKS siguiendo https://learn.microsoft.com/es-es/azure/developer/terraform/create-k8s-cluster-with-tf-and-aks
# genero valor aleatorio para log analytics
resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}
# log analytics
resource "azurerm_log_analytics_workspace" "test" {
  location            = var.log_analytics_workspace_location
  # The WorkSpace name has to be unique across the whole of azure;
  # not just the current subscription/tenant.
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = var.log_analytics_workspace_sku
}
# log analytics solution
resource "azurerm_log_analytics_solution" "test" {
  location              = azurerm_log_analytics_workspace.test.location
  resource_group_name   = azurerm_resource_group.rg.name
  solution_name         = "ContainerInsights"
  workspace_name        = azurerm_log_analytics_workspace.test.name
  workspace_resource_id = azurerm_log_analytics_workspace.test.id

  plan {
    product   = "OMSGallery/ContainerInsights"
    publisher = "Microsoft"
  }
}
# Creacion de ACR
resource "azurerm_container_registry" "ogsacr" {
  name                = "ogsacr"
  sku                 = "Standard"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}
# Creacion de Cluster AKS
resource "azurerm_kubernetes_cluster" "k8s" {
  location            = azurerm_resource_group.rg.location
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = var.dns_prefix
  tags                = {
    Environment = "UNIR Practica 2"
  }
  default_node_pool {
    name       = "agentpool"
    vm_size    = "Standard_D2_v2"
    node_count = var.agent_count
  }
  linux_profile {
    admin_username = "ubuntu"

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  network_profile {
    network_plugin    = "kubenet"
    load_balancer_sku = "standard"
  }
  service_principal {
    client_id     = var.aks_service_principal_app_id
    client_secret = var.aks_service_principal_client_secret
  }
 # Operaciones con ACR 
  provisioner "local-exec" {
 # Enlaza el ACR con el AKS
    command = "az aks update -n ${var.cluster_name} -g ${azurerm_resource_group.rg.name} --attach-acr ${azurerm_container_registry.ogsacr.name}"
 # Subida de la imagen nginx al ACR para su uso
    command = "az acr import --name ${azurerm_container_registry.ogsacr.name} --source docker.io/library/nginx:latest --image nginx:latest"
  }
}
