# Day 02 - AWS S3 Bucket Creation

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

### 3. S3 Bucket
The following resource creates an AWS S3 bucket:

```hcl
resource "aws_s3_bucket" "first_bucket" {
  bucket = "gastech-terraform-course-bucket"

  tags = {
    Name        = "Demo S3 Bucket"
    Environment = "Dev"
  }
}
```

**What this does:**
- `resource "aws_s3_bucket" "first_bucket"`: Creates an S3 bucket resource named "first_bucket"
- `bucket = "gastech-terraform-course-bucket"`: Sets the bucket name (must be globally unique across all AWS accounts)
- `tags`: Adds metadata labels to organize and manage resources

**Why tags are useful:**
Tags help you organize and track resources, making it easier to:
- Identify which environment a resource belongs to (Dev, Test, Prod)
- Automate management and billing tracking
- Filter resources in the AWS console

### 4. What this code does
In short, this Terraform file:
- declares the AWS provider,
- sets the AWS region to us-east-1,
- creates a new S3 bucket with a unique name,
- applies tags for easy identification and management.

### 5. Useful commands
To apply this configuration, you can execute:

```bash
terraform init
terraform plan
terraform apply
```

To destroy the resources created:

```bash
terraform destroy
```

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

### 3. Bucket S3
La ressource suivante crée un bucket S3 AWS :

```hcl
resource "aws_s3_bucket" "first_bucket" {
  bucket = "gastech-terraform-course-bucket"

  tags = {
    Name        = "Demo S3 Bucket"
    Environment = "Dev"
  }
}
```

**Ce que cela fait :**
- `resource "aws_s3_bucket" "first_bucket"` : Crée une ressource bucket S3 nommée "first_bucket"
- `bucket = "gastech-terraform-course-bucket"` : Définit le nom du bucket (doit être globalement unique sur tous les comptes AWS)
- `tags` : Ajoute des étiquettes de métadonnées pour organiser et gérer les ressources

**Pourquoi les tags sont utiles :**
Les tags aident à organiser et suivre les ressources, ce qui facilite :
- Identifier quel environnement une ressource appartient (Dev, Test, Prod)
- Automatiser la gestion et le suivi des coûts
- Filtrer les ressources dans la console AWS

### 4. Ce que fait ce code
En résumé, ce fichier Terraform :
- déclare le provider AWS,
- définit la région AWS à us-east-1,
- crée un nouveau bucket S3 avec un nom unique,
- applique des tags pour faciliter l'identification et la gestion.

### 5. Commandes utiles
Pour appliquer cette configuration, vous pouvez exécuter :

```bash
terraform init
terraform plan
terraform apply
```

Pour détruire les ressources créées :

```bash
terraform destroy
```
