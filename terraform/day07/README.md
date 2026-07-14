# Day 07 - Terraform count and for_each for Multiple S3 Buckets

## English

This README explains the Terraform project contained in this folder. Day 07 introduces two important Terraform patterns for creating multiple resources in a clean and scalable way: `count` and `for_each`.

### 1. What this project does
This configuration creates multiple AWS S3 buckets based on the list of names defined in the variables. It demonstrates how Terraform can manage several resources dynamically without duplicating code manually.

### 2. Remote backend configuration
The backend is configured in backend.tf:

```hcl
terraform {
  backend "s3" {
    bucket = "mybucket-gastech-terraform-course"
    key    = "backend/terraform.tfstate"
    region = "us-east-1"
  }
}
```

This stores the Terraform state remotely in an S3 bucket, which is useful for collaboration and centralized management.

### 3. AWS provider configuration
The AWS provider is declared in providers.tf:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

This tells Terraform to deploy resources in the us-east-1 region.

### 4. Variables used in this project
The variables are defined in variables.tf. One important variable is:

```hcl
variable "bucket_names" {
  description = "List of S3 bucket names to create"
  type        = list(string)
  default     = ["mybucket-gastech-terraform-course", "mybucket-gastech-terraform-course2"]
}
```

This list provides the names of the buckets that will be created.

### 5. Resources created by this configuration

#### First approach: using count
```hcl
resource "aws_s3_bucket" "first_bucket" {
  count = length(var.bucket_names)

  bucket = var.bucket_names[count.index]
  tags   = var.tags
}
```

The `count` argument creates one resource for each item in the list. It is useful when you want to create a fixed number of similar resources.

#### Second approach: using for_each
```hcl
resource "aws_s3_bucket" "second_bucket" {
  for_each = toset(var.bucket_names)
  bucket   = each.key
  tags     = var.tags

  depends_on = [aws_s3_bucket.first_bucket]
}
```

The `for_each` argument creates resources based on a map or set of values. It is particularly useful when each resource needs a distinct key and when you want cleaner and more explicit management of the created resources.

### 6. Why both patterns are useful
Terraform offers both patterns because they are suited to different situations:
- `count` is simple and convenient for creating a known number of identical resources,
- `for_each` is better when resources need to be identified individually and managed more flexibly.

### 7. What this day teaches you
Day 07 shows how to:
- create multiple S3 buckets from a list of names,
- use `count` for repeated resources,
- use `for_each` for more explicit resource management,
- and keep the configuration reusable and easier to maintain.

### 8. Useful commands
To initialize and apply the configuration:

```bash
terraform init
terraform plan
terraform apply
```

To destroy the created resources:

```bash
terraform destroy
```

---

## Français

Ce README explique le projet Terraform contenu dans ce dossier. Le Day 07 introduit deux patterns Terraform importants pour créer plusieurs ressources de manière propre et évolutive : `count` et `for_each`.

### 1. Ce que ce projet fait
Cette configuration crée plusieurs buckets S3 AWS à partir de la liste de noms définie dans les variables. Elle montre comment Terraform peut gérer plusieurs ressources de manière dynamique sans dupliquer manuellement le code.

### 2. Configuration du backend distant
Le backend est configuré dans backend.tf :

```hcl
terraform {
  backend "s3" {
    bucket = "mybucket-gastech-terraform-course"
    key    = "backend/terraform.tfstate"
    region = "us-east-1"
  }
}
```

Cela permet de stocker l’état Terraform à distance dans un bucket S3, ce qui est utile pour la collaboration et la gestion centralisée.

### 3. Configuration du provider AWS
Le provider AWS est déclaré dans providers.tf :

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
```

Cela indique à Terraform de déployer les ressources dans la région us-east-1.

### 4. Variables utilisées dans ce projet
Les variables sont définies dans variables.tf. Une variable importante est :

```hcl
variable "bucket_names" {
  description = "List of S3 bucket names to create"
  type        = list(string)
  default     = ["mybucket-gastech-terraform-course", "mybucket-gastech-terraform-course2"]
}
```

Cette liste fournit les noms des buckets qui seront créés.

### 5. Ressources créées par cette configuration

#### Première approche : utiliser count
```hcl
resource "aws_s3_bucket" "first_bucket" {
  count = length(var.bucket_names)

  bucket = var.bucket_names[count.index]
  tags   = var.tags
}
```

L’argument `count` crée une ressource pour chaque élément de la liste. Il est utile lorsque vous souhaitez créer un nombre connu de ressources similaires.

#### Deuxième approche : utiliser for_each
```hcl
resource "aws_s3_bucket" "second_bucket" {
  for_each = toset(var.bucket_names)
  bucket   = each.key
  tags     = var.tags

  depends_on = [aws_s3_bucket.first_bucket]
}
```

L’argument `for_each` crée des ressources à partir d’une map ou d’un set de valeurs. Il est particulièrement utile lorsque chaque ressource doit avoir une clé distincte et lorsqu’on veut une gestion plus explicite et flexible.

### 6. Pourquoi les deux patterns sont utiles
Terraform propose les deux patterns car ils sont adaptés à des situations différentes :
- `count` est simple et pratique pour créer un nombre connu de ressources identiques,
- `for_each` est mieux adapté lorsque les ressources doivent être identifiées individuellement et gérées plus librement.

### 7. Ce que ce jour vous apprend
Le Day 07 montre comment :
- créer plusieurs buckets S3 à partir d’une liste de noms,
- utiliser `count` pour des ressources répétitives,
- utiliser `for_each` pour une gestion plus explicite,
- et garder la configuration réutilisable et plus facile à maintenir.

### 8. Commandes utiles
Pour initialiser et appliquer la configuration :

```bash
terraform init
terraform plan
terraform apply
```

Pour détruire les ressources créées :

```bash
terraform destroy
```
