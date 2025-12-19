#!/usr/bin/env bash
set -e

TOPIC="mobile-events"
PARTITIONS=1
REPLICATION=1

docker exec kafka kafka-topics \
  --bootstrap-server kafka:9092 \
  --create \
  --if-not-exists \
  --topic "$TOPIC" \
  --partitions "$PARTITIONS" \
  --replication-factor "$REPLICATION"

echo "✅ Topic Kafka prêt: $TOPIC"
