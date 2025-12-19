#!/usr/bin/env bash
set -e

# Copie le fichier local dans le conteneur namenode
docker cp data/mobile_events_sample.txt namenode:/tmp/mobile_events_sample.txt

# Upload dans HDFS
docker exec namenode hdfs dfs -put -f /tmp/mobile_events_sample.txt /input/

docker exec namenode hdfs dfs -ls /input
echo "✅ Données envoyées vers HDFS: /input/mobile_events_sample.txt"