# Lux Network Monitoring Stack

Comprehensive monitoring solution for Lux Network with Grafana, Prometheus, and Loki.

## Components

- **Grafana** (Port 3100): Visualization and dashboards
- **Prometheus** (Port 9090): Metrics collection and storage
- **Loki** (Port 3101): Log aggregation
- **Promtail**: Log collection agent
- **Node Exporter** (Port 9100): System metrics
- **Postgres Exporter** (Port 9187): Database metrics
- **Alertmanager** (Port 9093): Alert management

## Quick Start

```bash
# Start the monitoring stack
cd /home/z/work/lux/monitoring
./start-monitoring.sh

# Deploy nginx configuration for monitor.lux.network
./deploy-monitor-nginx.sh
```

## Access Points

### Local Access
- Grafana: http://localhost:3100 (admin/luxnetwork)
- Prometheus: http://localhost:9090
- Loki: http://localhost:3101
- Alertmanager: http://localhost:9093

### Public Access (via nginx/Cloudflare)
- Grafana: https://monitor.lux.network

## What's Monitored

### Blockchain Metrics
- **C-Chain (EVM)**: Block height, processing rate, rejection rate, RPC metrics
- **P-Chain (Platform)**: Block height, validator info, staking metrics
- **X-Chain (DEX/Assets)**: Block height, transaction metrics, asset transfers

### System Metrics
- CPU, Memory, Disk usage
- Network I/O
- Process statistics

### Application Metrics
- Blockscout explorer performance
- PostgreSQL database metrics
- Docker container statistics

### Logs
- Lux node logs
- Docker container logs
- System logs

## Dashboards

### Pre-configured Dashboards
1. **Lux Network Comprehensive** - Overview of all chains
2. **C-Chain Dashboard** - Detailed C-Chain metrics
3. **P-Chain Dashboard** - Platform chain monitoring
4. **X-Chain Dashboard** - Asset chain monitoring
5. **Machine Metrics** - System resource usage
6. **Database Dashboard** - PostgreSQL performance
7. **Logs Dashboard** - Centralized log viewing

### Importing Additional Dashboards
The existing dashboards in `/monitoring/grafana/dashboards/` are automatically imported.

## Alerts

Configured alerts include:
- Node down detection
- Chain sync issues
- High block rejection rates
- Low peer count
- Resource usage warnings
- Database connectivity

## Configuration Files

- `compose.luxnet.yml` - Docker Compose configuration
- `prometheus/prometheus.yml` - Prometheus scrape configs
- `prometheus/alerts/*.yml` - Alert rules
- `loki/loki-config.yml` - Loki configuration
- `promtail/promtail-config.yml` - Log collection config
- `grafana/provisioning/` - Grafana auto-provisioning

## Maintenance

### View Logs
```bash
docker-compose -f compose.luxnet.yml logs -f
```

### Restart Services
```bash
docker-compose -f compose.luxnet.yml restart [service-name]
```

### Stop Monitoring
```bash
docker-compose -f compose.luxnet.yml down
```

### Update Configuration
1. Edit the relevant config file
2. Restart the affected service
3. Verify changes in Grafana

## Troubleshooting

### No metrics showing
1. Check if Lux node is running: `curl http://localhost:9650/ext/health`
2. Verify Prometheus targets: http://localhost:9090/targets
3. Check container logs: `docker-compose -f compose.luxnet.yml logs prometheus`

### Cannot access Grafana
1. Check if container is running: `docker ps | grep lux-grafana`
2. Verify port 3100 is not in use: `netstat -tulpn | grep 3100`
3. Check nginx configuration if using monitor.lux.network

### High memory usage
1. Adjust retention in `prometheus.yml`: `--storage.tsdb.retention.time=15d`
2. Configure Loki retention in `loki-config.yml`
3. Limit log ingestion in Promtail config

## Integration with Production

The monitoring stack integrates with your existing infrastructure:
- Uses `hanzo-network` for database access
- Monitors all running Blockscout instances
- Collects logs from Docker containers
- Tracks Lux node performance