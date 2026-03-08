#!/bin/sh
set -e

echo "=== myITCloud Build ==="
echo "Date: $(date)"
echo "Hostname: $(hostname)"

echo "--- Installing packages ---"
apk add --no-cache nginx curl

echo "--- Configuring nginx ---"
mkdir -p /var/www/html

# Generate index.html at boot with the actual hostname
cat > /etc/local.d/generate-index.start <<'SCRIPT'
#!/bin/sh
cat > /var/www/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head><title>CloudBuild Test</title></head>
<body><h1>Build successful!</h1><p>Hostname: $(hostname)</p><p>App Version: $APP_VERSION</p></body>
</html>
EOF
SCRIPT
chmod +x /etc/local.d/generate-index.start
rc-update add local default

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
