#!/usr/bin/env bash
set -e

docker exec namenode hdfs dfs -mkdir -p /input
docker exec namenode hdfs dfs -mkdir -p /output
docker exec namenode hdfs dfs -ls /
echo "✅ HDFS initialisé (/input, /output)"