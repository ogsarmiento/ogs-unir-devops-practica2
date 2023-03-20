# Detalles maquinas virtuales

resource "azurerm_linux_virtual_machine" "UNIRp2" {
    name                = "${var.vms[count.index]}-vm"
	count               = length(var.vms)
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = var.vms_flavors_id[count.index]
    admin_username      = "rocky"
    network_interface_ids = ["${element(azurerm_network_interface.mainNI.*.id, count.index)}"] 
    disable_password_authentication = true
# usuario rocky por defecto en distribuciones Rocky Linux
  admin_ssh_key {
    username   = "rocky"
    public_key = file(var.ssh_public_key)
  }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    plan {
        name      = "rockylinux-9"
        product   = "rockylinux-9"
        publisher = "erockyenterprisesoftwarefoundationinc1653071250513"
    }
# Imagen a utilizar
    source_image_reference {
        publisher = "erockyenterprisesoftwarefoundationinc1653071250513"
        offer     = "rockylinux-9"
        sku       = "rockylinux-9"
        version   = "latest"
    }
# etiquetas para localizar mas facilmente los recursos desplegados
    tags = {
        environment = "UNIR Practica 2"
    }

}