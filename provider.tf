provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

provider "azuread" {
}
provider "random" {
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.69.0" #"=2.95.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "2.40.0" #"2.17.0"
    }
   time = {
     source = "hashicorp/time"
     version = "0.7.2"
   }
    random = {
      source ="hashicorp/random"
      version = "3.1.0" #old: 2.2.1 #new : 3.1.0 but Jenkins unable to upgrade, awaiting Giordano/Simone to answer & install
    }
  }
}
