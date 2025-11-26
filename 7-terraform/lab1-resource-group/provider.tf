# configurar o provedor do AzureRM
provider "azurerm" {
  subscription_id = "1a961237-c303-462a-9dad-b85bf676ff25"
  # feature é que habilita recursos específicos do provedor
  features {

  }
}

# configurar a versão do provedor
terraform {
  # definir o provedor necessário
  required_providers {
    azurerm = {
      # especificar a fonte e a versão do provedor
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
  # definir a versão mínima do Terraform
  required_version = ">= 1.0.0"
}

