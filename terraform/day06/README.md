# Day 06 - Advanced Terraform Variables, Security Groups, and EC2 Provisioning

## English

This README explains the Terraform project contained in this folder. Day 06 is an important step because it introduces more advanced Terraform concepts such as complex variables, input validation patterns, reusable values, and security group rules for a cloud infrastructure deployment.

### 1. What this project does
This configuration provisions:
- one or more EC2 instances,
- a security group,
- inbound and outbound security group rules,
- and Terraform outputs to expose the created instance IDs.

Unlike the previous days, this project focuses less on simple resource creation and more on making the configuration flexible, reusable, and closer to real-world infrastructure practices.

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

This tells Terraform to store its state remotely in an S3 bucket, which is essential for:
- team collaboration,
- centralized state management,
- safer infrastructure changes,
- and better recovery and auditing.

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

This configures Terraform to deploy resources in the us-east-1 region.

### 4. Variables and advanced Terraform types
Day 06 makes heavy use of Terraform variables with different types.

#### Simple variables
```hcl
variable "environment" {
  default = "dev"
  type    = string
}

variable "instance_count" {
  type = number
}
```

#### Lists
```hcl
variable "allowed_region" {
  type    = list(string)
  default = ["us-east-1", "us-west-2", "eu-west-1"]
}
```

#### Maps
```hcl
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Name        = "dev-EC2-Instance"
    Project     = "TerraformDemo"
    created_by  = "Terraform"
  }
}
```

#### Objects
```hcl
variable "config" {
  type = object({
    region             = string
    instance_count     = number
    monitoring_enabled = bool
  })
}
```

#### Tuples
```hcl
variable "ingress_value" {
  type = tuple([number, string, number])
  default = [443, "tcp", 443]
}
```

These variable types make the configuration more expressive and allow Terraform to manage different deployment settings in a structured way.

### 5. Resources created by this configuration

#### EC2 instance
```hcl
resource "aws_instance" "example" {
  count         = var.instance_count
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = var.allowed_vm_types[1]
  region        = var.config.region

  monitoring                  = var.config.monitoring_enabled
  associate_public_ip_address = var.associate_public_ip

  tags = var.tags
}
```

This creates one or more EC2 instances using:
- the number defined in var.instance_count,
- the instance type selected from allowed_vm_types,
- the region from the config object,
- and the tags provided by the tags variable.

#### Security group
```hcl
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = var.tags
}
```

A security group acts like a firewall for the EC2 instance, controlling what traffic is allowed in and out.

#### Inbound and outbound rules
```hcl
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block[0]
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
```

```hcl
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
```

These resources allow inbound HTTPS traffic on port 443 and allow all outbound traffic.

### 6. Outputs
The project exposes the EC2 instance IDs through an output:

```hcl
output "ec2_instance_id" {
  value = aws_instance.example[*].id
}
```

Outputs are useful because they let you retrieve important values after deployment without manually inspecting the state.

### 7. What this day teaches you
Day 06 demonstrates a more advanced Terraform workflow:
- use different variable types to make infrastructure flexible,
- organize settings with objects and maps,
- define security rules for EC2 access,
- and use outputs to expose deployment results.

### 8. Useful commands
To initialize and apply this project:

```bash
terraform init
terraform plan
terraform apply
```

To remove the created infrastructure:

```bash
terraform destroy
```

---

## Français

Ce README explique le projet Terraform contenu dans ce dossier. Le Day 06 marque une étape importante, car il introduit des concepts Terraform plus avancés comme les variables complexes, les types de données variés, et les règles de sécurité pour un déploiement d’infrastructure cloud.

### 1. Ce que ce projet fait
Cette configuration provisionne :
- une ou plusieurs instances EC2,
- un security group,
- des règles d’entrée et de sortie pour ce groupe de sécurité,
- et des outputs Terraform pour exposer les identifiants des instances créées.

Contrairement aux jours précédents, ce projet ne se limite pas à une création simple de ressources : il met l’accent sur la flexibilité, la réutilisabilité et une approche plus réaliste de l’infrastructure.

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

Cela indique à Terraform de stocker l’état à distance dans un bucket S3, ce qui est essentiel pour :
- la collaboration en équipe,
- la centralisation de l’état,
- la sécurité des modifications d’infrastructure,
- et une meilleure récupération et audit.

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

Cette configuration indique à Terraform de déployer les ressources dans la région us-east-1.

### 4. Variables et types Terraform avancés
Le Day 06 utilise largement les variables Terraform avec différents types.

#### Variables simples
```hcl
variable "environment" {
  default = "dev"
  type    = string
}

variable "instance_count" {
  type = number
}
```

#### Listes
```hcl
variable "allowed_region" {
  type    = list(string)
  default = ["us-east-1", "us-west-2", "eu-west-1"]
}
```

#### Maps
```hcl
variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Name        = "dev-EC2-Instance"
    Project     = "TerraformDemo"
    created_by  = "Terraform"
  }
}
```

#### Objets
```hcl
variable "config" {
  type = object({
    region             = string
    instance_count     = number
    monitoring_enabled = bool
  })
}
```

#### Tuples
```hcl
variable "ingress_value" {
  type = tuple([number, string, number])
  default = [443, "tcp", 443]
}
```

Ces types de variables rendent la configuration plus expressive et permettent à Terraform de gérer différents paramètres de déploiement de manière structurée.

### 5. Ressources créées par cette configuration

#### Instance EC2
```hcl
resource "aws_instance" "example" {
  count         = var.instance_count
  ami           = "resolve:ssm:/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
  instance_type = var.allowed_vm_types[1]
  region        = var.config.region

  monitoring                  = var.config.monitoring_enabled
  associate_public_ip_address = var.associate_public_ip

  tags = var.tags
}
```

Cela crée une ou plusieurs instances EC2 en utilisant :
- le nombre défini dans var.instance_count,
- le type d’instance sélectionné dans allowed_vm_types,
- la région provenant de l’objet config,
- et les tags fournis par la variable tags.

#### Groupe de sécurité
```hcl
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = var.tags
}
```

Un security group agit comme un pare-feu pour l’instance EC2, en contrôlant les trafics autorisés en entrée et en sortie.

#### Règles d’entrée et de sortie
```hcl
resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block[0]
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
```

```hcl
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
```

Ces ressources autorisent le trafic HTTPS entrant sur le port 443 et tous les trafics sortants.

### 6. Outputs
Le projet expose les identifiants des instances EC2 via un output :

```hcl
output "ec2_instance_id" {
  value = aws_instance.example[*].id
}
```

Les outputs sont utiles parce qu’ils permettent de récupérer des valeurs importantes après le déploiement sans inspecter manuellement l’état.

### 7. Ce que ce jour vous apprend
Le Day 06 illustre un workflow Terraform plus avancé :
- utiliser différents types de variables pour rendre l’infrastructure flexible,
- organiser les paramètres avec des objets et des maps,
- définir des règles de sécurité pour l’accès aux EC2,
- et utiliser des outputs pour exposer les résultats du déploiement.

### 8. Commandes utiles
Pour initialiser et appliquer ce projet :

```bash
terraform init
terraform plan
terraform apply
```

Pour supprimer l’infrastructure créée :

```bash
terraform destroy
```
