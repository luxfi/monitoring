#!/bin/bash

# Deploy monitor.lux.network nginx configuration

set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
NGINX_CONF="/home/z/work/lux/nginx/monitor.lux.network.conf"
NGINX_SITES_ENABLED="/etc/nginx/sites-enabled/monitor.lux.network"

echo "Deploying monitor.lux.network nginx configuration..."

# Check if nginx config exists
if [ ! -f "$NGINX_CONF" ]; then
    echo "Error: Nginx config not found at $NGINX_CONF"
    exit 1
fi

# Create symlink to sites-enabled if it doesn't exist
if [ ! -L "$NGINX_SITES_ENABLED" ]; then
    echo "Creating symlink to sites-enabled..."
    sudo ln -s "$NGINX_CONF" "$NGINX_SITES_ENABLED"
else
    echo "Symlink already exists in sites-enabled"
fi

# Test nginx configuration
echo "Testing nginx configuration..."
sudo nginx -t

if [ $? -eq 0 ]; then
    echo "Nginx configuration is valid"
    echo "Reloading nginx..."
    sudo systemctl reload nginx
    echo "✓ monitor.lux.network is now configured"
    echo ""
    echo "Access URLs:"
    echo "  Local:    http://localhost:3100"
    echo "  Public:   https://monitor.lux.network"
    echo ""
    echo "Make sure to:"
    echo "1. Add DNS record for monitor.lux.network pointing to your server"
    echo "2. Configure Cloudflare SSL/TLS settings"
    echo "3. Start the monitoring stack: cd $SCRIPT_DIR && ./start-monitoring.sh"
else
    echo "Error: Nginx configuration test failed"
    exit 1
fi