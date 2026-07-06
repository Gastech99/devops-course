# Day 04 - Terraform Variables, Locals, and Multi-Resource Infrastructure

## English

This README explains the Terraform configuration written in the main.tf file of this folder. Day 04 is a major step forward because it introduces a more realistic and professional infrastructure pattern: remote state, variables, locals, and multiple AWS resources in the same project.

### 1. What this project creates
This configuration provisions:
- an S3 bucket,
- a VPC,
- an EC2 instance,
- and several Terraform outputs to expose useful identifiers.

It is a great example of how Terraform can manage a small but complete infrastructure stack in a clean and reusable way.

### 2. Terraform block and remote backend
The first section configures Terraform itself:

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

This means Terraform will store its state remotely in an S3 bucket instead of keeping it only on the local machine. This is extremely useful for:
- team collaboration,
- consistency across environments,
- safer infrastructure management,
- and better recovery from changes or mistakes.

### 3. AWS provider configuration
The AWS provider is configured for the us-east-1 region:

```hcl
provider "aws" {
  region = "us-east-1"
}
```

This tells Terraform that all AWS resources defined in this project should be created in the selected region.

### 4. Variables and locals
Day 04 introduces variables and locals to make the configuration dynamic and easier to maintain.

#### Variables
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

These variables allow you to adapt the deployment without changing the whole file manually.

#### Locals
```hcl
locals {
  bucket_name = "${var.channel-name}-bucket-${var.environment}"
  vpc_name    = "${var.environment}-vpc"
}
```

Locals are useful because they simplify repeated values and generate resource names dynamically.

### 5. Resources created by this configuration

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

This creates an S3 bucket whose name depends on the environment and channel name.

#### VPC
```hcl
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
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
  tags = {
    Environment = var.environment
    Name        = "${var.environment}-EC2-Instance"
  }
}
```

This launches a lightweight EC2 instance using the latest Amazon Linux 2023 AMI.

### 6. Outputs
The file also defines outputs so Terraform can display important information after deployment:

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "ec2_instance_id" {
  value = aws_instance.example.id
}
```

Outputs make it easier to retrieve and use identifiers from the created resources.

### 7. What this code demonstrates
In short, this Terraform project shows how to:
- configure a remote S3 backend,
- use variables for flexibility,
- use locals for cleaner naming,
- create multiple AWS resources together,
- and expose important resource IDs with outputs.

### 8. Useful commands
To apply this configuration, run:

```bash
terraform init
terraform plan
terraform apply
```

To remove the resources created:

```bash
terraform destroy
```

---

## Français

Ce README explique la configuration Terraform écrite dans le fichier main.tf de ce dossier. Le Day 04 marque une avancée importante, car il introduit un modèle d’infrastructure plus réaliste et professionnel : état distant, variables, locals, et plusieurs ressources AWS dans un même projet.

### 1. Ce que ce projet crée
Cette configuration provisionne :
- un bucket S3,
- un VPC,
- une instance EC2,
- ainsi que plusieurs outputs Terraform pour exposer des identifiants utiles.

C’est un excellent exemple de la manière dont Terraform peut gérer une petite pile d’infrastructure complète de façon propre et réutilisable.

### 2. Bloc Terraform et backend distant
La première section configure Terraform lui-même :

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

Cela signifie que Terraform stockera son état à distance dans un bucket S3 au lieu de le conserver uniquement localement. Cela est particulièrement utile pour :
- la collaboration en équipe,
- la cohérence entre environnements,
- une gestion plus sûre de l’infrastructure,
- et une meilleure récupération en cas d’erreur.

### 3. Configuration du provider AWS
Le provider AWS est configuré pour la région us-east-1 :

```hcl
provider "aws" {
  region = "us-east-1"
}
```

Cela indique à Terraform que toutes les ressources AWS définies dans ce projet doivent être créées dans cette région.

### 4. Variables et locals
Le Day 04 introduit les variables et les locals pour rendre la configuration plus dynamique et plus facile à maintenir.

#### Variables
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

Ces variables permettent d’adapter le déploiement sans modifier entièrement le fichier à chaque fois.

#### Locals
```hcl
locals {
  bucket_name = "${var.channel-name}-bucket-${var.environment}"
  vpc_name    = "${var.environment}-vpc"
}
```

Les locals sont pratiques car ils simplifient les valeurs répétées et génèrent les noms de ressources de manière dynamique.

### 5. Ressources créées par cette configuration

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
  tags = {
    Environment = var.environment
    Name        = "${var.environment}-EC2-Instance"
  }
}
```

Cette ressource lance une instance EC2 légère à l’aide de la dernière AMI Amazon Linux 2023.

### 6. Outputs
Le fichier définit aussi des outputs afin que Terraform puisse afficher des informations importantes après le déploiement :

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "ec2_instance_id" {
  value = aws_instance.example.id
}
```

Les outputs facilitent la récupération et l’utilisation des identifiants des ressources créées.

### 7. Ce que ce code démontre
En résumé, ce projet Terraform montre comment :
- configurer un backend S3 distant,
- utiliser des variables pour la flexibilité,
- utiliser des locals pour un nommage plus propre,
- créer plusieurs ressources AWS ensemble,
- et exposer des identifiants utiles avec des outputs.

### 8. Commandes utiles
Pour appliquer cette configuration, exécutez :

```bash
terraform init
terraform plan
terraform apply
```

Pour supprimer les ressources créées :

```bash
terraform destroy
```
