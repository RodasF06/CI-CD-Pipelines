terraform {
  required_version = ">= 1.14.8"

  cloud {
    
    organization = "Terr4F0rmD3m0rganization"

    workspaces {
      name = "workspace_proyect_3"
    }
  }
}

provider "aws" {
  region = var.region
}