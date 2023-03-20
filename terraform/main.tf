
# Grupo de recursos principal con un nombre en base a nombres de animales aleatorios
resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "azurerm_resource_group" "rg" {
  location = var.resource_group_location
  name     = random_pet.rg_name.id
    tags = {
        environment = "UNIR Practica 2"
    }
}