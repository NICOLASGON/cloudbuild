#!/bin/sh
set -e

echo "=== myITCloud Build ==="
echo "Date: $(date)"
echo "Hostname: $(hostname)"

echo "--- Installing packages ---"
apk add --no-cache nginx curl

echo "--- Configuring nginx ---"
mkdir -p /var/www/html
cat > /var/www/html/index.html <<'HTML'
<!DOCTYPE html>
<html>
<head><title>CloudBuild Test</title></head>
<body><h1>Build successful!</h1></body>
</html>
HTML

# Configure nginx to serve /var/www/html
cat > /etc/nginx/http.d/default.conf <<'NGINX'
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    root /var/www/html;
    index index.html;
    location / {
        try_files $uri $uri/ =404;
    }
}
NGINX

# Auto-start nginx on boot
rc-update add nginx default

echo "--- Build complete ---"
