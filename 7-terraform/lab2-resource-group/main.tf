# data é usado para referenciar recursos existentes no Azure
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name # var. é que vai utilizar alguma variavel do arquivo variables.tf (no caso, resource_group_name)
}

# Exemplo de criação de um recurso novo (public ip)
resource "azurerm_public_ip" "public_ip" {
  name                = "devops-public-ip"
  location            = var.location                        # var. é que vai utilizar alguma variavel do arquivo variables.tf (no caso, location)
  resource_group_name = data.azurerm_resource_group.rg.name # data. é usado para referenciar recursos existentes no Azure
  sku                 = "Standard"
  allocation_method   = "Static"
}

# Exemplo de criação de um recurso novo (virtual network)
resource "azurerm_virtual_network" "vnet" {
  name                = "devops-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name # vai utilizar o resource group criado acima
}

# Exemplo de criação de um recurso novo (subnet)
resource "azurerm_subnet" "subnet" {
  name                 = "devops-subnet"
  resource_group_name  = data.azurerm_resource_group.rg.name # vai utilizar o resource group criado acima
  virtual_network_name = azurerm_virtual_network.vnet.name   # vai utilizar a virtual network criada acima
  address_prefixes     = ["10.0.1.0/24"]
}

# Exemplo de criação de um recurso novo (network interface)
resource "azurerm_network_interface" "nic" {
  name                = "devops-nic"                        # nome da network interface
  location            = var.location                        # localização
  resource_group_name = data.azurerm_resource_group.rg.name # vai utilizar o resource group criado acima

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id # vai utilizar a subnet criada acima
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id # vai utilizar o public ip criado acima
  }

}

# Exemplo de criação de um recurso novo (virtual machine)
resource "azurerm_virtual_machine" "vm" {
  name                  = "devops-vm"
  location              = var.location
  resource_group_name   = data.azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = "Standard_B1s"

  # Configuração do disco do sistema operacional
  storage_os_disk {
    name              = "devops-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Configuração da imagem do sistema operacional
  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  # Configuração do perfil do sistema operacional
  os_profile {
    computer_name  = "devops-vm"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  # Configuração do perfil do sistema operacional Linux
  os_profile_linux_config {
    disable_password_authentication = false # permite autenticação por senha
  }
}

# Exemplo de criação de um recurso novo (network security group)
resource "azurerm_network_security_group" "nsg" {
  name                = "devops-nsg"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  # Regra de segurança para permitir SSH
  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Regra de segurança para permitir HTTP na porta 8081
  security_rule {
    name                       = "Allow-HTTP-8081"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8081"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Associação do network security group à network interface
resource "azurerm_network_interface_security_group_association" "nic_nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}