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

echo "--- Build complete ---"
