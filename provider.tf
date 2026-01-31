terraform {

  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "forgtechtfstate123"
    container_name       = "tfstate"
    key                  = "hubspoke.terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100.0"
    }
  }
}


provider "azurerm" {

  

  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
