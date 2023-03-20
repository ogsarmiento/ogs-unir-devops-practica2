# Repositorio privado de imagenes
#resource "azurerm_container_registry" "UNIRp2ACR" {
#  name                = "UNIRp2ACR"
#  resource_group_name = azurerm_resource_group.rg.name
#  location            = azurerm_resource_group.rg.location
#  sku                 = "Standard"
#  admin_enabled       = false
#  tags = {
#        environment = "UNIR Practica 2"
#    }
#}


#resource "azurerm_role_assignment" "role_UNIRp2ACR_pull" {
#  scope                            = azurerm_container_registry.UNIRp2ACR.id
#  role_definition_name             = "AcrPull"
#  principal_id                     = azurerm_kubernetes_cluster.k8s.kubelet_identity.0.object_id
#  skip_service_principal_aad_check = true
#}