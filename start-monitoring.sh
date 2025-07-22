#!/bin/bash

# Start Lux Network Monitoring Stack
# This script starts Grafana, Prometheus, Loki, and associated services

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

echo "Starting Lux Network Monitoring Stack..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker first."
    exit 1
fi

# Check if hanzo-network exists, create if not
if ! docker network inspect hanzo-network > /dev/null 2>&1; then
    echo "Creating hanzo-network..."
    docker network create hanzo-network
fi

# Create necessary directories if they don't exist
mkdir -p prometheus/alerts
mkdir -p grafana/dashboards

# Check if Lux node is accessible
echo "Checking Lux node connectivity..."
if ! curl -s http://localhost:9650/ext/health > /dev/null; then
    echo "Warning: Lux node at localhost:9650 is not accessible"
    echo "Monitoring will start but node metrics won't be available"
fi

# Start the monitoring stack
echo "Starting monitoring services..."
docker-compose -f compose.luxnet.yml up -d

# Wait for services to start
echo "Waiting for services to initialize..."
sleep 10

# Check service health
echo -e "\nChecking service status:"
docker-compose -f compose.luxnet.yml ps

echo -e "\nService URLs:"
echo "  Grafana:       http://localhost:3100 (admin/luxnetwork)"
echo "  Prometheus:    http://localhost:9090"
echo "  Loki:          http://localhost:3101"
echo "  Alertmanager:  http://localhost:9093"
echo ""
echo "To view logs: docker-compose -f compose.luxnet.yml logs -f"
echo "To stop:      docker-compose -f compose.luxnet.yml down"