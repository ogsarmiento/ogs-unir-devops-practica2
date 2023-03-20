# Red

resource "azurerm_virtual_network" "myNet" {
    name                = "UNIRp2-net"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    tags = {
        environment = "UNIR Practica 2"
    }
}

# subred

resource "azurerm_subnet" "mySubnet" {
    name                   = "UNIRp2-subnet"
    resource_group_name    = azurerm_resource_group.rg.name
    virtual_network_name   = azurerm_virtual_network.myNet.name
    address_prefixes       = ["10.0.1.0/24"]

}


# IP pública

resource "azurerm_public_ip" "myPublicIp" {
  name                = "pubip-${var.vms[count.index]}"
  count               = length(var.vms)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"

    tags = {
        environment = "UNIR Practica 2"
    }

}


# Interfaz de red

resource "azurerm_network_interface" "mainNI" {
  name                = "nic-${var.vms[count.index]}"  
  count               = length(var.vms)
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
    name                           = "ipconf-${var.vms[count.index]}"
    subnet_id                      = azurerm_subnet.mySubnet.id 
    private_ip_address_allocation  = "Static"
    private_ip_address             = "10.0.1.${count.index + 10}"
    public_ip_address_id           = azurerm_public_ip.myPublicIp[count.index].id
  }

    tags = {
        environment = "UNIR Practica 2"
    }

}

