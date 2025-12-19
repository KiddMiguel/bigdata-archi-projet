# 🧠 C’est quoi Hadoop Streaming (très simplement)

👉 **Hadoop Streaming est un mode d’utilisation de MapReduce**
👉 Il permet d’utiliser **n’importe quel langage** (Python, Bash, etc.)
👉 au lieu d’écrire du **Java Hadoop compliqué**

### Phrase simple à retenir

> **Hadoop Streaming permet d’exécuter des scripts (ex : Python) comme des jobs MapReduce.**

---

# ❌ Sans Hadoop Streaming (le monde compliqué)

Si Hadoop Streaming n’existait pas :

* Tu devrais écrire :

  * un `Mapper` Java
  * un `Reducer` Java
* Compiler du Java
* Gérer des classes Hadoop
* Beaucoup de code, très verbeux

❌ **Pas adapté à un projet pédagogique**
❌ **Trop lourd pour ton objectif**

---

# ✅ Avec Hadoop Streaming (TON projet)

Avec Hadoop Streaming :

* Tu écris :

  * `mapper.py`
  * `reducer.py`
* Hadoop se charge de :

  * distribuer les données
  * lancer les scripts
  * paralléliser le calcul
  * regrouper les résultats

👉 **Tu te concentres sur la logique métier**, pas sur Hadoop interne.

---

# 🎬 Scénario concret DANS TON PROJET

## 🎯 Objectif métier

> *Savoir combien de fois chaque écran de l’application mobile est utilisé.*

---

## 1️⃣ Les données (dans HDFS)

Dans `/input/mobile_events_sample.txt` :

```
2025-01-01 08:00:05 user22 CHECKOUT CLICK 200 0.159
2025-01-01 08:00:06 user141 PRODUCT API_CALL 200 0.31
2025-01-01 08:00:15 user205 HOME API_CALL 404 0.104
```

👉 Hadoop va lire **ce fichier ligne par ligne**

---

## 2️⃣ Hadoop Streaming appelle ton **mapper.py**

Ton `mapper.py` fait ça :

```python
print("CHECKOUT\t1")
print("PRODUCT\t1")
print("HOME\t1")
```

👉 Il transforme les lignes brutes en **clé → valeur**

🧠 **Le mapper prépare les données**, il ne calcule pas encore.

---

## 3️⃣ Hadoop fait le travail “magique” (important)

⚠️ **Tu ne codes PAS ça**, Hadoop s’en charge :

* il regroupe automatiquement :

```
CHECKOUT → [1, 1, 1, 1]
PRODUCT  → [1, 1]
HOME     → [1, 1, 1]
```

👉 Cette étape s’appelle le **shuffle & sort**

---

## 4️⃣ Hadoop Streaming appelle ton **reducer.py**

Ton `reducer.py` reçoit :

```
CHECKOUT    1
CHECKOUT    1
CHECKOUT    1
```

Il calcule :

```
CHECKOUT    3
```

🧠 **Le reducer résume**, **agrège**, **conclut**

---

## 5️⃣ Hadoop écrit le résultat dans `/output`

Dans :

```
/output/job1_events_by_screen/part-00000
```

Tu obtiens :

```
HOME        1
PRODUCT     1
CHECKOUT    1
```

👉 **C’est de l’information utile**, pas juste des logs.

---

# 🔁 Pourquoi on appelle ça “Streaming” alors ?

⚠️ Très important :
**Hadoop Streaming ≠ Kafka streaming**

### Hadoop Streaming :

* “Streaming” = *les données passent par stdin/stdout*
* Pas du temps réel
* C’est du **batch**

👉 Mauvais nom, mais historique.

---

### Kafka Streaming (TON Kafka) :

* Vrai temps réel
* Événements instantanés

👉 **Deux choses totalement différentes**

---

# 🧩 Pourquoi Hadoop Streaming est PARFAIT pour ton projet

| Besoin                      | Solution         |
| --------------------------- | ---------------- |
| Traiter beaucoup de données | Hadoop           |
| Pas écrire du Java          | Hadoop Streaming |
| Utiliser Python             | Hadoop Streaming |
| Projet pédagogique          | Hadoop Streaming |

---

# 🎤 Phrase parfaite à dire au prof

> *Hadoop Streaming nous permet d’exécuter des scripts Python comme des jobs MapReduce, sans avoir à développer en Java, tout en bénéficiant du traitement distribué de Hadoop.*

💯 **Phrase clé.**

---

# 🧠 Résumé en 5 lignes (à mémoriser)

* Hadoop Streaming = **MapReduce en Python**
* Le mapper **transforme** les données
* Hadoop **regroupe** automatiquement
* Le reducer **agrège**
* Le résultat est stocké dans HDFS