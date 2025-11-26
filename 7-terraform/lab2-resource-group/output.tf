output "vm_name" {
  description = "Nome da máquina virtual"
  value       = azurerm_virtual_machine.vm.name
}

output "public_ip_address" {
  description = "ID do endereço IP público"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "network_interface" {
  description = "ID da interface de rede"
  value       = azurerm_network_interface.nic.name
}