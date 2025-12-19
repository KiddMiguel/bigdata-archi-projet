#!/usr/bin/env bash
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=================================================="
echo "🚀 DEMO Big Data - Mobile App Analytics"
echo "   Kafka (stream), HDFS, MapReduce, Postgres/Metabase"
echo "=================================================="
cd "$PROJECT_ROOT"

# -------- Helpers --------
need_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "❌ Commande manquante: $1"
    exit 1
  }
}

wait_container() {
  local name="$1"
  echo "⏳ Attente container: $name ..."
  for i in {1..60}; do
    if docker ps --format '{{.Names}}' | grep -q "^${name}$"; then
      echo "✅ $name UP"
      return 0
    fi
    sleep 2
  done
  echo "❌ $name n'est pas UP après attente."
  docker ps
  exit 1
}

# -------- Checks --------
need_cmd docker
need_cmd docker-compose || need_cmd docker  # docker compose possible
need_cmd python || need_cmd python3

PYTHON_BIN="python"
command -v python >/dev/null 2>&1 || PYTHON_BIN="python3"

echo ""
echo "1) 🐳 Démarrage des services Docker..."
docker-compose up -d

wait_container "namenode"
wait_container "datanode"
wait_container "resourcemanager"
wait_container "kafka"
wait_container "postgres"
wait_container "metabase"

echo ""
echo "2) 🧪 Génération du dataset (10k events)..."
$PYTHON_BIN data/generator.py

echo ""
echo "3) 🗂️ Initialisation HDFS (/input, /output)..."
bash hdfs/hdfs_init.sh

echo ""
echo "4) ⬆️ Upload des données dans HDFS..."
bash hdfs/hdfs_put.sh

echo ""
echo "5) ⚙️ Lancement MapReduce Job1 (events by screen)..."
bash mapreduce/job1_events_by_screen/run.sh

echo ""
echo "6) 🧺 Export résultats Job1 -> PostgreSQL..."
# dépendance python ETL
if ! $PYTHON_BIN -c "import psycopg2" >/dev/null 2>&1; then
  echo "📦 Installation psycopg2-binary..."
  $PYTHON_BIN -m pip install --quiet psycopg2-binary
fi

$PYTHON_BIN etl/export_job1_to_postgres.py

echo ""
echo "7) 🔎 Vérification PostgreSQL (top rows)..."
docker exec -i postgres psql -U bigdata -d analytics -c \
"SELECT screen, event_count FROM kpi_events_by_screen ORDER BY event_count DESC LIMIT 10;"

echo ""
echo "✅ Démo terminée."
echo ""
echo "📌 UIs:"
echo " - HDFS NameNode : http://localhost:9870"
echo " - YARN          : http://localhost:8088"
echo " - Metabase      : http://localhost:3000"
echo ""
echo "💡 Streaming Kafka (à lancer en live si tu veux pendant la démo) :"
echo " - Terminal A: $PYTHON_BIN kafka/consumer.py"
echo " - Terminal B: $PYTHON_BIN kafka/producer.py"
echo ""
