# Day 08 - Lifecycle Rules, Launch Templates, and Auto Scaling

## English

This README explains the Terraform project contained in this folder. Day 08 introduces more advanced AWS concepts by combining a lifecycle policy, a launch template, and an Auto Scaling Group to build a more realistic infrastructure pattern.

### 1. What this project does
This configuration creates:
- an EC2 instance,
- a launch template for future instance creation,
- and an Auto Scaling Group that manages a group of EC2 instances automatically.

The goal is to demonstrate how Terraform can define infrastructure that is resilient, scalable, and easier to manage over time.

### 2. AWS provider configuration
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

This configures Terraform to deploy resources in the us-east-1 region.

### 3. EC2 instance with lifecycle rules
The first resource is an EC2 instance:

```hcl
resource "aws_instance" "example" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = var.allowed_vm_types[1]
  region        = tolist(var.allowed_region)[0]

  tags = var.tags

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
  }
}
```

This block introduces Terraform lifecycle rules:
- `create_before_destroy = true` means Terraform will create a new instance before replacing the old one.
- `prevent_destroy = true` prevents the resource from being destroyed accidentally.

These settings are useful when you want safer rolling updates and protection against accidental deletions.

### 4. Launch template
A launch template defines the configuration used to create EC2 instances in the Auto Scaling Group:

```hcl
resource "aws_launch_template" "app_server" {
  name_prefix   = "app-server-"
  image_id      = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = var.allowed_vm_types[1]

  tag_specifications {
    resource_type = "instance"

    tags = var.tags
  }
}
```

A launch template is useful because it centralizes the instance configuration and allows the Auto Scaling Group to launch new instances consistently.

### 5. Auto Scaling Group
The Auto Scaling Group manages the number of running instances:

```hcl
resource "aws_autoscaling_group" "app_servers" {
  name                 = "app-servers-asg"
  max_size             = 5
  min_size             = 1
  desired_capacity     = 2
  health_check_type   = "EC2"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  launch_template {
    id      = aws_launch_template.app_server.id
    version = "$Latest"
  }
}
```

This configuration ensures that:
- at least one instance is running,
- up to five instances can be created,
- two instances are desired by default,
- and the group uses the launch template for new instances.

### 6. What this day teaches you
Day 08 shows how to:
- protect resources with lifecycle rules,
- create reusable launch templates,
- manage instances with an Auto Scaling Group,
- and build a more production-like infrastructure structure.

### 7. Useful commands
To initialize and apply the configuration:

```bash
terraform init
terraform plan
terraform apply
```

To remove the created infrastructure:

```bash
terraform destroy
```

> Note: because `prevent_destroy = true` is enabled, destroying this infrastructure may require changing the configuration first.

---

## Français

Ce README explique le projet Terraform contenu dans ce dossier. Le Day 08 introduit des concepts AWS plus avancés en combinant une politique de lifecycle, un launch template et un Auto Scaling Group pour construire un modèle d’infrastructure plus réaliste.

### 1. Ce que ce projet fait
Cette configuration crée :
- une instance EC2,
- un launch template pour la création future d’instances,
- et un Auto Scaling Group qui gère automatiquement un groupe d’instances EC2.

L’objectif est de montrer comment Terraform peut définir une infrastructure plus robuste, évolutive et facile à gérer dans le temps.

### 2. Configuration du provider AWS
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

Cela configure Terraform pour déployer les ressources dans la région us-east-1.

### 3. Instance EC2 avec règles de lifecycle
La première ressource est une instance EC2 :

```hcl
resource "aws_instance" "example" {
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = var.allowed_vm_types[1]
  region        = tolist(var.allowed_region)[0]

  tags = var.tags

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
  }
}
```

Ce bloc introduit des règles de lifecycle Terraform :
- `create_before_destroy = true` signifie que Terraform créera une nouvelle instance avant de remplacer l’ancienne.
- `prevent_destroy = true` empêche la ressource d’être détruite accidentellement.

Ces paramètres sont utiles lorsqu’on veut des mises à jour plus sûres et une protection contre les suppressions accidentelles.

### 4. Launch template
Un launch template définit la configuration utilisée pour créer des instances EC2 dans le Auto Scaling Group :

```hcl
resource "aws_launch_template" "app_server" {
  name_prefix   = "app-server-"
  image_id      = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = var.allowed_vm_types[1]

  tag_specifications {
    resource_type = "instance"

    tags = var.tags
  }
}
```

Un launch template est utile car il centralise la configuration des instances et permet au Auto Scaling Group de lancer de nouvelles instances de façon cohérente.

### 5. Auto Scaling Group
Le Auto Scaling Group gère le nombre d’instances en exécution :

```hcl
resource "aws_autoscaling_group" "app_servers" {
  name                 = "app-servers-asg"
  max_size             = 5
  min_size             = 1
  desired_capacity     = 2
  health_check_type   = "EC2"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
  launch_template {
    id      = aws_launch_template.app_server.id
    version = "$Latest"
  }
}
```

Cette configuration garantit que :
- au moins une instance est en cours d’exécution,
- jusqu’à cinq instances peuvent être créées,
- deux instances sont désirées par défaut,
- et le groupe utilise le launch template pour les nouvelles instances.

### 6. Ce que ce jour vous apprend
Le Day 08 montre comment :
- protéger les ressources avec des règles de lifecycle,
- créer des launch templates réutilisables,
- gérer des instances avec un Auto Scaling Group,
- et construire une infrastructure plus proche d’un environnement de production.

### 7. Commandes utiles
Pour initialiser et appliquer la configuration :

```bash
terraform init
terraform plan
terraform apply
```

Pour supprimer l’infrastructure créée :

```bash
terraform destroy
```

> Note : puisque `prevent_destroy = true` est activé, détruire cette infrastructure peut exiger de modifier la configuration au préalable.
