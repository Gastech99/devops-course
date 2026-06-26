# Day 01 - Terraform Basics

## English

This README explains the Terraform code written in the main.tf file of this folder.

### 1. Terraform block
The first section defines the required providers for the project:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

This tells Terraform that the AWS provider is required and that version 6.x should be used.

### 2. AWS provider configuration
The provider block configures the AWS provider:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

This means that all AWS resources created by this configuration will be deployed in the us-east-1 region.

### 3. Virtual Private Cloud (VPC)
The following resource creates a VPC:

```hcl
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
```

This creates a network with the IP range 10.0.0.0/16, which is the private address space used by the VPC.

### 4. What this code does
In short, this Terraform file:
- declares the AWS provider,
- sets the AWS region to us-east-1,
- creates a new VPC with a CIDR block.

### 5. Multiple Provider Versions
You can also declare more than one provider in the same Terraform configuration. For example:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
}
```

This example shows that Terraform can manage multiple providers at the same time, such as AWS and Random.

---

## Français

Ce README explique le code Terraform écrit dans le fichier main.tf de ce dossier.

### 1. Bloc Terraform
La première section définit les providers nécessaires au projet :

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

Cela indique à Terraform que le provider AWS est obligatoire et que la version 6.x doit être utilisée.

### 2. Configuration du provider AWS
Le bloc provider configure le provider AWS :

```hcl
provider "aws" {
  region = "us-east-1"
}
```

Cela signifie que toutes les ressources AWS créées par cette configuration seront déployées dans la région us-east-1.

### 3. VPC (Virtual Private Cloud)
La ressource suivante crée un VPC :

```hcl
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}
```

Cela crée un réseau avec la plage IP 10.0.0.0/16, qui correspond à l’espace d’adresses privé du VPC.

### 4. Ce que fait ce code
En résumé, ce fichier Terraform :
- déclare le provider AWS,
- définit la région AWS à us-east-1,
- crée un nouveau VPC avec un bloc CIDR.

### 5. Commande utile
Pour appliquer cette configuration, vous pouvez exécuter :

```bash
terraform init
terraform plan
terraform apply
```
