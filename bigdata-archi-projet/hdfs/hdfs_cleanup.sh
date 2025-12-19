#!/usr/bin/env bash
set -e

docker exec namenode hdfs dfs -rm -r -f /output/*
docker exec namenode hdfs dfs -rm -r -f /tmp_output || true
echo "✅ Outputs nettoyés"