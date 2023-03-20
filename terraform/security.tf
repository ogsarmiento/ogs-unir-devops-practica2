# Security group

resource "azurerm_network_security_group" "SGunirp2" {
    name                = "SGunirp2"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    # Regla para permitir el acceso via SSH a las maquinas creadas 
    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    # Regla para permitir el acceso via 8080 al webserver 
    security_rule {
        name                       = "HTTP-8080"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "8080"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    tags = {
        environment = "UNIR Practica 2"
    }
}

# Anadir security group a interfaz de red

resource "azurerm_network_interface_security_group_association" "SGAssociation1" {
    network_interface_id      = "${element(azurerm_network_interface.mainNI.*.id, count.index)}"        #azurerm_network_interface.myNic1.id
    network_security_group_id = azurerm_network_security_group.SGunirp2.id
	count                     = length(var.vms)

}