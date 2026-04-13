# TP 8 - Déploiement d'une Application Multi-Services

## Description

Infrastructure Terraform pour déployer une application multi-services conteneurisée avec Docker.

Cette configuration permet de :
- ✅ Déployer des services sélectifs par environnement (dev/prod)
- ✅ Gérer plusieurs instances (replicas) de chaque service
- ✅ Activer/désactiver les services dynamiquement
- ✅ Isoler les ports externes pour éviter les conflits

## Architecture

```
Tp8/
├── providers.tf          # Configuration du provider Docker
├── versions.tf           # Version de Terraform et requirements
├── variables.tf          # Variables principales
├── locals.tf             # Logique de filtrage des services
├── main.tf               # Appel du module avec for_each
├── outputs.tf            # Outputs des services déployés
└── modules/
    └── service/          # Module réutilisable pour chaque service
        ├── versions.tf
        ├── variable.tf
        ├── main.tf
        └── outputs.tf
```

## Services Disponibles

- **frontend** (nginx:latest)
  - Port interne: 80
  - Port externe: 8080 (8081, 8082... pour replicas)
  - Environnement: dev

- **backend** (node:18-alpine)
  - Port interne: 3000
  - Port externe: 3001 (3002, 3003... pour replicas)
  - Environnement: dev

- **database** (postgres:15-alpine)
  - Port interne: 5432
  - Port externe: 5433 (5434, 5435... pour replicas)
  - Environnement: dev

- **cache** (redis:7-alpine)
  - Port interne: 6379
  - Port externe: 6380 (6381, 6382... pour replicas)
  - Environnement: dev

## Variables

### Variable principale : `environment`
```hcl
variable "environment" {
  description = "Environnement de déploiement (dev ou prod)"
  type        = string
  default     = "dev"
}
```

### Variable complexe : `services`
Structure complète pour configurer chaque service :
```hcl
{
  service_name = {
    name          = "nom du service"
    image         = "image:tag"
    port_internal = 8080        # Port interne du conteneur
    port_external = 8080        # Port exposé sur l'hôte
    environment   = "dev"       # Environnement cible
    replicas      = 1           # Nombre d'instances
    enable        = true        # Activer/désactiver le service
  }
}
```

## Logique de Filtrage

Les services sont filtrés selon deux critères dans `locals.tf` :

1. **Par environnement** : Seuls les services correspondant à la variable `environment` sont déployés
2. **Par activation** : Seuls les services avec `enable = true` sont déployés

### Gestion des Replicas

Pour chaque service activé, Terraform crée automatiquement `N` instances où `N` = nombre de replicas.
Les ports externes sont incrémentés pour éviter les conflits :
- Replica 0 → port 8080
- Replica 1 → port 8081
- Replica 2 → port 8082
- etc.

## Commandes Principales

### Initialisation
```bash
terraform init
```

### Formatage
```bash
terraform fmt -recursive
```

### Validation
```bash
terraform validate
```

### Planification
```bash
terraform plan
```

### Déploiement
```bash
terraform apply
```

### Destruction
```bash
terraform destroy
```

## Outputs

Le projet expose plusieurs outputs :

1. **deployed_services** : Résumé complet de chaque service déployé
2. **services_summary** : Vue d'ensemble (environnement, nombre total de services)
3. **service_details** : Détails de chaque type de service

## Module Service

Le module `modules/service/` est réutilisable et responsable de :
- Télécharger l'image Docker
- Créer le conteneur
- Mapper les ports
- Configurer les labels

### Inputs du module
- `name` : Nom du conteneur
- `image` : Image Docker
- `port_internal` : Port interne
- `port_external` : Port externe
- `environment` : Environnement

### Outputs du module
- `container_id` : ID du conteneur
- `container_name` : Nom du conteneur
- `container_image` : Image utilisée
- `port_internal` : Port interne
- `port_external` : Port externe

## Utilisation

### Déployer uniquement dev
```bash
terraform apply
```

### Déployer uniquement frontend en dev
Modifier `variables.tf` :
```hcl
backend.enable = false
database.enable = false
cache.enable = false
```

### Ajouter des replicas
Modifier `variables.tf` :
```hcl
frontend.replicas = 3  # Créera 3 instances du frontend
```

## Notes de Sécurité

- Les conteneurs sont limités mais pas isolés avec resource limits
- Pas d'authentification Docker implémentée
- Les variables doivent être complétées selon vos besoins de sécurité
