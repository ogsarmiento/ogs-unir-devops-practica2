# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
# Provider de Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.0"
    }
  }
  required_version = ">= 1.1.0"
}

# No es recomendable exponer estos datos en entornos productivos
provider "azurerm" {
  features {}
  subscription_id   = "5545d9e7-c794-4579-a986-1d06df94e2f0"
  tenant_id         = "899789dc-202f-44b4-8472-a6d40f9eb440"
  client_id         = "d5396033-940f-4364-ab72-1c0ba9fe1ab1"
  client_secret     = "RtJ8Q~WRfYjNBzN9JPWvoxqHBjcqMFudEkKwnckJ"
}