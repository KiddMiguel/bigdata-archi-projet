#!/usr/bin/env bash
set -e

echo "=============================================="
echo "🧨 RESET COMPLET — BigData Archi Projet"
echo "=============================================="

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$PROJECT_ROOT"

echo ""
echo "1️⃣ Arrêt et suppression des containers du projet..."
docker-compose down --volumes --remove-orphans

echo ""
echo "2️⃣ Suppression des images Docker liées au projet..."
IMAGES=$(docker images --format "{{.Repository}} {{.ID}}" | grep -E "bigdata|hadoop|kafka|metabase|postgres" | awk '{print $2}' | sort -u)

if [ -n "$IMAGES" ]; then
  docker rmi -f $IMAGES || true
else
  echo "ℹ️ Aucune image spécifique à supprimer"
fi

echo ""
echo "3️⃣ Nettoyage des volumes Docker du projet..."
VOLUMES=$(docker volume ls --format "{{.Name}}" | grep -E "bigdata|hadoop|postgres|metabase" || true)

if [ -n "$VOLUMES" ]; then
  docker volume rm $VOLUMES || true
else
  echo "ℹ️ Aucun volume spécifique à supprimer"
fi

echo ""
echo "4️⃣ Nettoyage des réseaux Docker du projet..."
NETWORKS=$(docker network ls --format "{{.Name}}" | grep -E "bigdata|hadoop" || true)

if [ -n "$NETWORKS" ]; then
  docker network rm $NETWORKS || true
else
  echo "ℹ️ Aucun réseau spécifique à supprimer"
fi

echo ""
echo "5️⃣ Nettoyage des outputs locaux MapReduce..."
rm -rf mapreduce/**/output* || true
rm -rf mapreduce/**/result* || true

echo ""
echo "6️⃣ Nettoyage des fichiers temporaires..."
find . -name "__pycache__" -type d -exec rm -rf {} + || true
find . -name "*.pyc" -delete || true

echo ""
echo "✅ RESET TERMINÉ"
echo ""
echo "👉 Le projet est revenu à l'état initial."
echo "👉 Tu peux relancer la démo avec :"
echo ""
echo "   bash scripts/demo.sh"
echo ""
