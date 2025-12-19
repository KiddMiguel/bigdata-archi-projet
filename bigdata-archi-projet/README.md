# 📘 Projet Big Data — Analyse du trafic d’une application mobile

## 1. Contexte du projet

Ce projet est réalisé dans le cadre du module **Open Data / Big Data & Intelligence Artificielle**.
Il a pour objectif de concevoir et de mettre en œuvre une **architecture Big Data** permettant de traiter un grand volume de données générées par une **application mobile**, en combinant :

* le **traitement en temps réel (streaming)**
* le **traitement différé (batch)**

Les technologies utilisées sont **open source** et conformes à celles vues en cours.

---

## 2. Thème du projet

### 🎯 Analyse Big Data du trafic d’une application mobile

Une application mobile génère en continu des **événements utilisateurs**, tels que :

* ouverture d’écrans,
* clics,
* appels API,
* réponses serveur.

Ces événements sont exploités afin de **comprendre l’usage de l’application** et **évaluer la performance des requêtes**.

---

## 3. Objectifs du projet

Les objectifs principaux sont :

* Mettre en place une **architecture Big Data complète**
* Ingestion de données en **temps réel**
* Stockage distribué de données volumineuses
* Traitement batch pour l’analyse historique
* Extraction d’indicateurs métiers simples

### Indicateurs analysés :

* Nombre d’événements par écran
* Nombre d’événements par type
* Temps de réponse moyen par écran
* Identification des écrans lents (> 0,6 s)

---

## 4. Architecture globale

L’architecture repose sur trois composants principaux :

* **Kafka** : ingestion des événements en temps réel
* **HDFS** : stockage distribué des données (Data Lake)
* **MapReduce** : traitement batch et agrégation des données

### Schéma simplifié :

```
[ Application mobile ]
           |
           v
        Kafka
           |
           v
        HDFS
           |
           v
      MapReduce
           |
           v
     Résultats
```

Cette architecture correspond à une **architecture de type Lambda**, combinant batch et streaming.

---

## 5. Description des technologies utilisées

### 🔹 Apache Kafka

Kafka permet de simuler l’arrivée d’événements en temps réel générés par l’application mobile.
Il est utilisé pour le **stream processing**.

### 🔹 HDFS (Hadoop Distributed File System)

HDFS est utilisé comme **Data Lake**, permettant de stocker un grand volume de données de manière distribuée, avec tolérance aux pannes.

### 🔹 MapReduce

MapReduce est utilisé pour effectuer des **traitements batch** sur les données stockées dans HDFS, afin de calculer des statistiques et indicateurs globaux.

---

## 6. Organisation du projet

```
bigdata-archi-projet/
├─ data/        → Données et générateur d’événements
├─ hdfs/        → Scripts de gestion HDFS
├─ kafka/       → Producer et consumer Kafka
├─ mapreduce/   → Jobs MapReduce
├─ scripts/     → Scripts de démonstration
├─ docker-compose.yml
└─ README.md
```

---

## 7. Format des données

Chaque événement mobile est représenté sous la forme suivante :

```
DATE HEURE USER SCREEN EVENT_TYPE HTTP_CODE RESPONSE_TIME
```

Exemple :

```
2025-01-01 10:23 user42 HOME_SCREEN API_CALL 200 0.234
```

---

## 8. Lancement du projet (vue d’ensemble)

### 1️⃣ Démarrer l’environnement

```bash
docker-compose up -d
```

### 2️⃣ Initialiser HDFS

```bash
bash hdfs/hdfs_init.sh
```

### 3️⃣ Charger les données dans HDFS

```bash
bash hdfs/hdfs_put.sh
```

### 4️⃣ Lancer un job MapReduce

```bash
bash mapreduce/job1_events_by_screen/run.sh
```

### 5️⃣ Lancer le streaming Kafka

```bash
python kafka/producer.py
python kafka/consumer.py
```

---

## 9. Répartition des tâches (exemple)

* Membre 1 : Architecture & HDFS
* Membre 2 : MapReduce (batch processing)
* Membre 3 : Kafka (stream processing)
* Membre 4 : Documentation & présentation

---

## 10. Conclusion

Ce projet illustre la mise en œuvre d’une **architecture Big Data simple et fonctionnelle**, capable de gérer des données volumineuses et continues, tout en respectant les concepts fondamentaux du Big Data vus en cours.