module "vnet" {
  source              = "../../modules/azurerm_vnet"
  vnet_name           = "dev-india-VNet"
  resource_group_name = "bps-dev-india-rg"
  address_space       = ["10.0.0.0/16"]
  location            = "centralindia"
}

module "subnet" {
  depends_on           = [module.vnet]
  source               = "../../modules/azurerm_subnet"
  address_prefixes     = ["10.0.0.0/24"]
  virtual_network_name = "dev-india-VNet"
  subnet_name          = "bps-dev-frontend-subnet"
  resource_group_name  = "bps-dev-india-rg"
}

module "subnet1" {
  depends_on           = [module.vnet]
  source               = "../../modules/azurerm_subnet"
  address_prefixes     = ["10.0.1.0/24"]
  virtual_network_name = "dev-india-VNet"
  subnet_name          = "bps-dev-backend-subnet"
  resource_group_name  = "bps-dev-india-rg"
}

module "nic" {
  depends_on           = [module.subnet]
  source               = "../../modules/azurerm_nic"
  virtual_network_name = "dev-india-VNet"
  subnet_name          = "bps-dev-frontend-subnet"
  resource_group_name  = "bps-dev-india-rg"
  nic_name             = "frontend-nic"
  location             = "centralindia"
  publicip_name        = "frontend-pip"
}

module "nic1" {
  depends_on           = [module.subnet1]
  source               = "../../modules/azurerm_nic"
  virtual_network_name = "dev-india-VNet"
  subnet_name          = "bps-dev-backend-subnet"
  resource_group_name  = "bps-dev-india-rg"
  nic_name             = "backend-nic"
  location             = "centralindia"
  publicip_name        = "backend-pip"
}

module "pip" {
  depends_on          = [module.vnet]
  source              = "../../modules/azurerm_public_ip"
  resource_group_name = "bps-dev-india-rg"
  pip_name            = "frontend-pip"
  location            = "centralindia"
}

module "pip1" {
  depends_on          = [module.vnet]
  source              = "../../modules/azurerm_public_ip"
  resource_group_name = "bps-dev-india-rg"
  pip_name            = "backend-pip"
  location            = "centralindia"
}

module "vm" {
  depends_on = [ module.nic ]
  source              = "../../modules/azurerm_VM"
  vm_name             = "bps-dev-frontend-VM"
  resource_group_name = "bps-dev-india-rg"
  location            = "centralindia"
  size                = "Standard_B2s"
  computer_name       = "ghost"
  os_disk_name        = "frontend-os-disk"
  publisher           = "Canonical"
  offer               = "0001-com-ubuntu-server-jammy"
  sku                 = "22_04-lts"
  version1            = "latest"
  key_vault_name      = "ket-vault0001"
  username_secret_key = "frontend-vm-username"
  pwd_secret_key      = "frontend-vm-pwd"
  nic_name            = "frontend-nic"
}

module "vm1" {
  depends_on = [ module.nic1 ]
  source              = "../../modules/azurerm_VM"
  vm_name             = "bps-dev-backend-VM"
  resource_group_name = "bps-dev-india-rg"
  location            = "centralindia"
  size                = "Standard_B2s"
  computer_name       = "ghostkabapp"
  os_disk_name        = "backend-os-disk"
  publisher           = "Canonical"
  offer               = "0001-com-ubuntu-server-focal"
  sku                 = "20_04-lts"
  version1            = "latest"
  key_vault_name      = "ket-vault0001"
  username_secret_key = "backend-vm-username"
  pwd_secret_key      = "backend-vm-pwd"
  nic_name            = "backend-nic"
}