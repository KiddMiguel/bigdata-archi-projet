#!/usr/bin/env bash
set -e

HADOOP_BIN="/opt/hadoop-3.2.1/bin/hadoop"
STREAMING_JAR="/opt/hadoop-3.2.1/share/hadoop/tools/lib/hadoop-streaming-3.2.1.jar"

# 1) Python3
docker exec namenode bash -lc "python3 --version" >/dev/null 2>&1 || \
docker exec namenode bash -lc "apt-get update && apt-get install -y python3"

# 2) Copier scripts
docker cp mapreduce/job1_events_by_screen/mapper.py namenode:/tmp/mapper.py
docker cp mapreduce/job1_events_by_screen/reducer.py namenode:/tmp/reducer.py
docker exec namenode chmod +x /tmp/mapper.py /tmp/reducer.py

# 3) Nettoyer output
docker exec namenode hdfs dfs -rm -r -f /output/job1_events_by_screen || true

# 4) Lancer streaming (sans -files)
docker exec namenode bash -lc "
${HADOOP_BIN} jar ${STREAMING_JAR} \
  -D mapreduce.job.name='job1_events_by_screen' \
  -input /input/mobile_events_sample.txt \
  -output /output/job1_events_by_screen \
  -mapper 'python3 /tmp/mapper.py' \
  -reducer 'python3 /tmp/reducer.py'
"

echo "✅ Résultat (aperçu):"
docker exec namenode hdfs dfs -cat /output/job1_events_by_screen/part-00000 | head -n 20
