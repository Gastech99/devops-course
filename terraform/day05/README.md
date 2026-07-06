# Day 05 - Terraform Project Structure, Variables, and Environment Configuration

## English

This README explains the Terraform project contained in this folder. Day 05 is a very important step because it moves from a single-file configuration to a more professional and scalable structure. Instead of keeping everything in one file, the infrastructure is organized across multiple Terraform files, making the project easier to read, maintain, and evolve.

### 1. What this project does
This configuration provisions a small AWS infrastructure composed of:
- an S3 bucket,
- a VPC,
- an EC2 instance,
- and Terraform outputs that expose important resource IDs.

What makes Day 05 special is not only the resources themselves, but also the way the project is organized.

### 2. Why this structure is better
In previous days, the Terraform code was written in a single file. In Day 05, the configuration is split into several files:
- backend.tf: configures the remote S3 backend,
- providers.tf: declares the AWS provider,
- variables.tf: defines input variables,
- locals.tf: defines reusable local values,
- main.tf: contains the main resources,
- outputs.tf: exposes important values after deployment,
- terraform.tfvars: provides environment-specific values.

This modular structure is much closer to real-world Terraform projects because it improves:
- readability,
- separation of concerns,
- reusability,
- and maintainability.

### 3. Remote backend configuration
The backend is defined in backend.tf:

```hcl
terraform {
  backend "s3" {
    bucket = "mybucket-gastech-terraform-course"
    key    = "backend/terraform.tfstate"
    region = "us-east-1"
  }
}
```

This tells Terraform to store the state remotely in an S3 bucket. Remote state is essential for:
- collaboration between team members,
- centralizing infrastructure state,
- reducing the risk of local state conflicts,
- and improving recovery and auditing.

### 4. AWS provider configuration
The AWS provider is configured in providers.tf:

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

This means that all AWS resources created by this project will be deployed in the us-east-1 region.

### 5. Variables and environment values
The input variables are declared in variables.tf:

```hcl
variable "environment" {
  default = "dev"
  type    = string
}

variable "channel-name" {
  default = "gastech"
}

variable "region" {
  default = "us-east-1"
}
```

The file terraform.tfvars provides values for these variables:

```hcl
environment = "pre-prod"
```

This is a very important Terraform practice because it separates configuration values from the logic. In other words, the infrastructure code stays reusable while the values change depending on the environment.

### 6. Locals for cleaner naming
The locals are defined in locals.tf:

```hcl
locals {
  bucket_name = "${var.channel-name}-bucket-${var.environment}"
  vpc_name    = "${var.environment}-vpc"
}
```

These locals allow Terraform to generate consistent names dynamically. For example, with the value `pre-prod` for the environment, the resulting bucket name becomes:

```text
gastech-bucket-pre-prod
```

This is much cleaner than hardcoding names manually throughout the project.

### 7. Resources deployed by this configuration

#### S3 bucket
```hcl
resource "aws_s3_bucket" "first_bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = var.environment
  }
}
```

This creates an S3 bucket whose name is derived from the environment and channel name.

#### VPC
```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  region     = var.region
  tags = {
    Environment = var.environment
    Name        = local.vpc_name
  }
}
```

This resource creates a private network for the infrastructure.

#### EC2 instance
```hcl
resource "aws_instance" "example" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t3.micro"
  region        = var.region
  tags = {
    Environment = var.environment
    Name        = "${var.environment}-EC2-Instance"
  }
}
```

This launches a lightweight EC2 instance using the latest Amazon Linux 2023 AMI.

### 8. Outputs
The outputs are defined in outputs.tf:

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "ec2_instance_id" {
  value = aws_instance.example.id
}
```

Outputs are very useful because they give you the IDs of the created resources after deployment, which can be reused in automation, documentation, or future infrastructure changes.

### 9. What this day teaches you
Day 05 demonstrates a more professional Terraform workflow:
- use a remote backend for state,
- separate configuration into multiple files,
- use variables for flexibility,
- use locals for cleaner naming,
- use tfvars for environment-specific values,
- and expose useful information with outputs.

### 10. Useful commands
To initialize and apply this project:

```bash
terraform init
terraform plan
terraform apply
```

To destroy the created infrastructure:

```bash
terraform destroy
```

---

## Français

Ce README explique le projet Terraform contenu dans ce dossier. Le Day 05 représente une étape très importante, car il passe d’une configuration unique à une structure plus professionnelle et plus évolutive. Au lieu de conserver tout le code dans un seul fichier, l’infrastructure est organisée dans plusieurs fichiers Terraform, ce qui rend le projet plus lisible, plus maintenable et plus adapté à un usage réel.

### 1. Ce que ce projet fait
Cette configuration provisionne une petite infrastructure AWS composée de :
- un bucket S3,
- un VPC,
- une instance EC2,
- et des outputs Terraform qui exposent les identifiants des ressources importantes.

Ce qui rend le Day 05 spécial, ce n’est pas seulement les ressources elles-mêmes, mais aussi la manière dont le projet est organisé.

### 2. Pourquoi cette structure est meilleure
Dans les jours précédents, le code Terraform était écrit dans un seul fichier. Dans le Day 05, la configuration est répartie dans plusieurs fichiers :
- backend.tf : configure le backend S3 distant,
- providers.tf : déclare le provider AWS,
- variables.tf : définit les variables d’entrée,
- locals.tf : définit des valeurs locales réutilisables,
- main.tf : contient les ressources principales,
- outputs.tf : expose des valeurs importantes après le déploiement,
- terraform.tfvars : fournit des valeurs spécifiques à l’environnement.

Cette structure modulaire est beaucoup plus proche des projets Terraform réels, car elle améliore :
- la lisibilité,
- la séparation des responsabilités,
- la réutilisabilité,
- et la maintenabilité.

### 3. Configuration du backend distant
Le backend est défini dans backend.tf :

```hcl
terraform {
  backend "s3" {
    bucket = "mybucket-gastech-terraform-course"
    key    = "backend/terraform.tfstate"
    region = "us-east-1"
  }
}
```

Cela indique à Terraform de stocker l’état à distance dans un bucket S3. L’état distant est essentiel pour :
- la collaboration entre membres d’une équipe,
- la centralisation de l’état de l’infrastructure,
- la réduction des conflits liés à un état local,
- et l’amélioration de la récupération et de l’audit.

### 4. Configuration du provider AWS
Le provider AWS est configuré dans providers.tf :

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

Cela signifie que toutes les ressources AWS créées par ce projet seront déployées dans la région us-east-1.

### 5. Variables et valeurs d’environnement
Les variables d’entrée sont déclarées dans variables.tf :

```hcl
variable "environment" {
  default = "dev"
  type    = string
}

variable "channel-name" {
  default = "gastech"
}

variable "region" {
  default = "us-east-1"
}
```

Le fichier terraform.tfvars fournit des valeurs à ces variables :

```hcl
environment = "pre-prod"
```

C’est une pratique Terraform très importante, car elle sépare les valeurs de configuration de la logique. En d’autres termes, le code d’infrastructure reste réutilisable tandis que les valeurs changent selon l’environnement.

### 6. Locals pour un nommage propre
Les locals sont définis dans locals.tf :

```hcl
locals {
  bucket_name = "${var.channel-name}-bucket-${var.environment}"
  vpc_name    = "${var.environment}-vpc"
}
```

Ces locals permettent à Terraform de générer des noms cohérents de manière dynamique. Par exemple, avec la valeur `pre-prod` pour l’environnement, le nom du bucket résultant devient :

```text
gastech-bucket-pre-prod
```

C’est beaucoup plus propre que de coder les noms manuellement dans tout le projet.

### 7. Ressources déployées par cette configuration

#### Bucket S3
```hcl
resource "aws_s3_bucket" "first_bucket" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = var.environment
  }
}
```

Cette ressource crée un bucket S3 dont le nom dépend de l’environnement et du nom du canal.

#### VPC
```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  region     = var.region
  tags = {
    Environment = var.environment
    Name        = local.vpc_name
  }
}
```

Cette ressource crée un réseau privé pour l’infrastructure.

#### Instance EC2
```hcl
resource "aws_instance" "example" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = "t3.micro"
  region        = var.region
  tags = {
    Environment = var.environment
    Name        = "${var.environment}-EC2-Instance"
  }
}
```

Cette ressource lance une instance EC2 légère à l’aide de la dernière AMI Amazon Linux 2023.

### 8. Outputs
Les outputs sont définis dans outputs.tf :

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "ec2_instance_id" {
  value = aws_instance.example.id
}
```

Les outputs sont très utiles car ils donnent accès aux identifiants des ressources créées après le déploiement, ce qui peut être réutilisé dans l’automatisation, la documentation ou de futurs changements d’infrastructure.

### 9. Ce que ce jour vous apprend
Le Day 05 démontre un workflow Terraform plus professionnel :
- utiliser un backend distant pour l’état,
- séparer la configuration en plusieurs fichiers,
- utiliser des variables pour la flexibilité,
- utiliser des locals pour un nommage plus propre,
- utiliser tfvars pour des valeurs spécifiques à l’environnement,
- et exposer des informations utiles avec des outputs.

### 10. Commandes utiles
Pour initialiser et appliquer ce projet :

```bash
terraform init
terraform plan
terraform apply
```

Pour détruire l’infrastructure créée :

```bash
terraform destroy
```
