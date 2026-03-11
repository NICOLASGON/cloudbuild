#!/bin/sh
cat > /usr/share/nginx/html/index.html <<EOF
<!DOCTYPE html>
<html>
<head>
  <title>CloudBuild Test</title>
  <style>
    body { font-family: sans-serif; display: flex; justify-content: center; align-items: center; min-height: 100vh; margin: 0; background: #f0f4f8; }
    .card { background: white; border-radius: 12px; padding: 2rem 3rem; box-shadow: 0 2px 8px rgba(0,0,0,0.1); text-align: center; }
    h1 { color: #2563eb; }
    .info { color: #475569; font-size: 1.1rem; margin: 0.5rem 0; }
    .label { font-weight: bold; color: #1e293b; }
  </style>
</head>
<body>
  <div class="card">
    <h1>Build successful!</h1>
    <p class="info"><span class="label">Hostname:</span> $(hostname)</p>
    <p class="info"><span class="label">App Version:</span> ${APP_VERSION}</p>
    <p class="info"><span class="label">Environment:</span> ${APP_ENVIRONMENT}</p>
  </div>
</body>
</html>
EOF
