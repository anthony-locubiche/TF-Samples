terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.55"
    }
  }
}
resource "random_password" "password_vm" {
  length           = 24
  min_numeric      = 1
  min_lower        = 1
  min_upper        = 1
  min_special      = 1
  special          = true
  override_special = "_%!'"
}

resource "azurerm_key_vault_secret" "secret_password" {
  name         = "${var.vm_name}-password"
  value        = random_password.password_vm.result
  key_vault_id = var.keyvault_id
}

resource "azurerm_key_vault_secret" "secret_username" {
  name         = "${var.vm_name}-username"
  value        = var.admin_username
  key_vault_id = var.keyvault_id
}

#VMS
resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_name}-nic-1"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = var.nic_ip_configuration_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.rg_location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = var.OS_publisher
    offer     = var.OS_offer
    sku       = var.OS_sku
    version   = var.OS_version
  }

  os_profile {
    computer_name  = var.vm_name
    admin_username = var.admin_username
    admin_password = random_password.password_vm.result
  }

  os_profile_windows_config {
    enable_automatic_upgrades = false
    provision_vm_agent        = var.enabled_vm_agent
  }

  storage_os_disk {
    name              = "${var.vm_name}-osdisk"
    create_option     = "FromImage"
    disk_size_gb      = var.os_disk_size_gb
  }

  tags= merge( {"ST-Project-Name"=format("%s", upper("COMMON"))}, var.tags.common)
}