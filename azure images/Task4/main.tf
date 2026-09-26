terraform {
  required_version = ">= 1.6.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "lab" {
  name     = var.resource_group_name
  location = var.location

  tags = var.tags
}

resource "azurerm_virtual_network" "lab" {
  name                = var.vnet_name
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  address_space       = [var.vnet_address_space]

  tags = var.tags
}

resource "azurerm_subnet" "web" {
  name                 = var.web_subnet_name
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = [var.web_subnet_prefix]
}

resource "azurerm_subnet" "db" {
  name                 = var.db_subnet_name
  resource_group_name  = azurerm_resource_group.lab.name
  virtual_network_name = azurerm_virtual_network.lab.name
  address_prefixes     = [var.db_subnet_prefix]
}

resource "azurerm_network_security_group" "lab" {
  name                = "NSG-AzureNetworking-Lab"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.allowed_ssh_source
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.lab.id
}

resource "azurerm_subnet_network_security_group_association" "db" {
  subnet_id                 = azurerm_subnet.db.id
  network_security_group_id = azurerm_network_security_group.lab.id
}

resource "azurerm_public_ip" "vm01" {
  name                = "pip-vm01"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_public_ip" "vm02" {
  name                = "pip-vm02"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = var.tags
}

resource "azurerm_network_interface" "vm01" {
  name                = "nic-vm01"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm01.id
  }

  tags = var.tags
}

resource "azurerm_network_interface" "vm02" {
  name                = "nic-vm02"
  location            = azurerm_resource_group.lab.location
  resource_group_name = azurerm_resource_group.lab.name

  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = azurerm_subnet.db.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vm02.id
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm01" {
  name                            = "VM01"
  resource_group_name             = azurerm_resource_group.lab.name
  location                        = azurerm_resource_group.lab.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.vm01.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "vm02" {
  name                            = "VM02"
  resource_group_name             = azurerm_resource_group.lab.name
  location                        = azurerm_resource_group.lab.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true
  network_interface_ids           = [azurerm_network_interface.vm02.id]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_private_dns_zone" "internal" {
  name                = var.private_dns_zone_name
  resource_group_name = azurerm_resource_group.lab.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "lab" {
  name                  = "vnet-link"
  resource_group_name   = azurerm_resource_group.lab.name
  private_dns_zone_name = azurerm_private_dns_zone.internal.name
  virtual_network_id    = azurerm_virtual_network.lab.id
  registration_enabled  = false

  tags = var.tags
}

resource "azurerm_private_dns_a_record" "vm01" {
  name                = "vm01"
  zone_name           = azurerm_private_dns_zone.internal.name
  resource_group_name = azurerm_resource_group.lab.name
  ttl                 = 300
  records             = [azurerm_network_interface.vm01.private_ip_address]
}

resource "azurerm_private_dns_a_record" "vm02" {
  name                = "vm02"
  zone_name           = azurerm_private_dns_zone.internal.name
  resource_group_name = azurerm_resource_group.lab.name
  ttl                 = 300
  records             = [azurerm_network_interface.vm02.private_ip_address]
}

resource "azurerm_dns_zone" "public" {
  count               = var.enable_public_dns ? 1 : 0
  name                = var.public_dns_zone
  resource_group_name = azurerm_resource_group.lab.name

  tags = var.tags
}

resource "azurerm_dns_a_record" "public_vm01" {
  count               = var.enable_public_dns ? 1 : 0
  name                = "vm01"
  zone_name           = azurerm_dns_zone.public[0].name
  resource_group_name = azurerm_resource_group.lab.name
  ttl                 = 300
  records             = [azurerm_public_ip.vm01.ip_address]
}

resource "azurerm_dns_a_record" "public_vm02" {
  count               = var.enable_public_dns ? 1 : 0
  name                = "vm02"
  zone_name           = azurerm_dns_zone.public[0].name
  resource_group_name = azurerm_resource_group.lab.name
  ttl                 = 300
  records             = [azurerm_public_ip.vm02.ip_address]
}
