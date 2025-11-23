terraform {
  required_version = ">= 1.0.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }

  backend "local" {
    # The state file will be created in this same folder as "terraform.tfstate"
    path = "terraform.tfstate"
  }
}

provider "random" {}

resource "random_pet" "example" {
  length = 2
  prefix = "statefile"
}

output "pet_name" {
  value = random_pet.example.id
}
