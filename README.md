# 🚴 DECATHLON Digital - Analytics Technical Case
## Évaluation du succès économique d'une expérimentation commerciale (Domyos)

## 📌 1. Contexte Métier
En 2023, une initiative stratégique a été lancée chez Décathlon pour optimiser l'offre en magasin en réduisant le nombre de références disponibles. 

Le directeur commercial de la marque **Domyos** a identifié le **kit d'haltères de 10 kg** comme un candidat idéal pour un retrait des rayons. L'hypothèse sous-jacente est la suivante : face à l'indisponibilité du kit 10 kg, les clients reporteront leurs achats sur des alternatives existantes (kits de 20 kg ou poids unitaires), compensant ainsi intégralement la perte de chiffre d'affaires.

### 📊 Paramètres de l'A/B Test
* **Période de test** : 7 semaines consécutives (Semaines 35 à 41 de l'année 2023).
* **Période de pré-test (historique)** : 7 semaines consécutives (Semaines 28 à 34 de l'année 2023).
* **Périmètre Géographique** : Une sélection de magasins "Test" (où le kit 10 kg a été retiré) comparée à un groupe de magasins "Contrôle" (offre inchangée).

---

## 🏗️ 2. Architecture de Données dbt
Ce projet applique les standards de l'Analytics Engineering (Medallion Architecture) afin de transformer les données brutes issues de l'entrepôt en tables prêtes pour la Business Intelligence (BI).

```text
models/
├── staging/
│   └── decathlon/
│       ├── src_decathlon.yml           # Déclaration des tables sources
│       ├── stg_decathlon__fact_sales.sql # Nettoyage et typage des ventes
│       ├── stg_decathlon__fact_stock.sql # Nettoyage et typage des stocks
│       ├── stg_decathlon__dim_store.sql  # Référentiel magasins
│       └── stg_decathlon__dim_model.sql  # Référentiel produits
└── marts/
    └── marketing/
        └── mart_ab_test_performance.sql # Analyse A/B Test finale

## 🚀 Utilisation

Pour lancer les tests de qualité et générer les modèles :
```bash
dbt run
dbt test