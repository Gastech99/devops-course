# Day 03 - Terraform Remote State with S3 Backend

## English

This README explains the Terraform code written in the main.tf file of this folder.

### 1. Terraform block and backend configuration
The first section defines the Terraform backend and required providers:

```hcl
terraform {

    backend "s3" {
    bucket = "mybucket-gastech-terraform-course"
    key    = "backend/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

This block configures Terraform to store its state file remotely in an AWS S3 bucket. The `backend "s3"` section defines:
- `bucket`: the S3 bucket name used to store the Terraform state file,
- `key`: the path inside the bucket for the state file,
- `region`: the AWS region where the backend bucket is located.

Using a remote backend is important for collaboration, state locking, and recovering the current infrastructure state.

### 2. AWS provider configuration
The provider block configures the AWS provider:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

This means that all AWS resources created by this configuration will be deployed in the us-east-1 region.

### 3. S3 Bucket resource
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

This resource creates a bucket named `gastech-terraform-course-bucket` and adds tags for organization.

### 4. Why remote state is useful
Remote state is useful because it:
- keeps Terraform state centralized,
- avoids local state file conflicts,
- enables team collaboration,
- improves disaster recovery,
- allows state locking when used with DynamoDB (not shown here).

### 5. What this code does
In short, this Terraform file:
- configures an S3 backend for remote Terraform state,
- declares the AWS provider,
- sets the AWS region to us-east-1,
- creates a new S3 bucket with tags.

### 6. Useful commands
To use this configuration, run:

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

### 1. Bloc Terraform et configuration du backend
La première section définit le backend Terraform et les providers requis :

```hcl
terraform {

    backend "s3" {
    bucket = "mybucket-gastech-terraform-course"
    key    = "backend/terraform.tfstate"
    region = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}
```

Ce bloc configure Terraform pour stocker son état à distance dans un bucket S3 AWS. La section `backend "s3"` définit :
- `bucket` : le nom du bucket S3 utilisé pour stocker l’état Terraform,
- `key` : le chemin du fichier d’état à l’intérieur du bucket,
- `region` : la région AWS où se trouve le bucket de backend.

Utiliser un backend distant est important pour la collaboration, le verrouillage d’état et la récupération de l’état actuel de l’infrastructure.

### 2. Configuration du provider AWS
Le bloc provider configure le provider AWS :

```hcl
provider "aws" {
  region = "us-east-1"
}
```

Cela signifie que toutes les ressources AWS créées par cette configuration seront déployées dans la région us-east-1.

### 3. Ressource Bucket S3
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

Cette ressource crée un bucket nommé `gastech-terraform-course-bucket` et ajoute des tags pour l’organisation.

### 4. Pourquoi l’état distant est utile
L’état distant est utile car il :
- centralise l’état Terraform,
- évite les conflits de fichier d’état local,
- facilite la collaboration en équipe,
- améliore la récupération après incident,
- permet le verrouillage d’état avec DynamoDB (non montré ici).

### 5. Ce que fait ce code
En résumé, ce fichier Terraform :
- configure un backend S3 pour l’état Terraform distant,
- déclare le provider AWS,
- définit la région AWS à us-east-1,
- crée un nouveau bucket S3 avec des tags.

### 6. Commandes utiles
Pour utiliser cette configuration, exécutez :

```bash
terraform init
terraform plan
terraform apply
```

Pour détruire les ressources créées :

```bash
terraform destroy
```
