#!/usr/bin/env bash
# Reinicia el static server + cloudflared tunnel para el demo NFC.
# Imprime la URL pública nueva al final.

set -euo pipefail

PROJECT_DIR="$HOME/Trabajo/Documentos/nfc-etiexpress-demo"
STATIC_PORT=8444
TUNNEL_LOG="/tmp/nfc-demo-tunnel.log"
SERVER_LOG="/tmp/nfc-demo-server.log"

cd "$PROJECT_DIR"

# Matar instancias previas
echo "→ Matando instancias previas..."
lsof -ti :$STATIC_PORT | xargs -r kill 2>/dev/null || true
pkill -f "cloudflared tunnel --url" 2>/dev/null || true
sleep 1

# Static server
echo "→ Arrancando static server en puerto $STATIC_PORT..."
nohup python3 -m http.server $STATIC_PORT --bind 127.0.0.1 > "$SERVER_LOG" 2>&1 &
disown
sleep 2

# Verifica que el server respondió
if ! curl -fsS -m 5 -o /dev/null http://localhost:$STATIC_PORT/; then
  echo "✗ Static server no arrancó. Revisa $SERVER_LOG"
  exit 1
fi
echo "  ✓ Static server OK"

# Cloudflared tunnel
echo "→ Arrancando cloudflared tunnel..."
nohup cloudflared tunnel --url "http://localhost:$STATIC_PORT" > "$TUNNEL_LOG" 2>&1 &
disown

# Esperar URL
echo -n "→ Esperando URL pública"
for i in {1..30}; do
  URL=$(grep -oE "https://[a-z0-9-]+\.trycloudflare\.com" "$TUNNEL_LOG" 2>/dev/null | head -1)
  if [ -n "$URL" ]; then
    echo " ✓"
    break
  fi
  echo -n "."
  sleep 1
done

if [ -z "$URL" ]; then
  echo ""
  echo "✗ No se pudo obtener URL del tunnel. Revisa $TUNNEL_LOG"
  exit 1
fi

# Esperar a que DNS propague
echo -n "→ Verificando DNS"
for i in {1..30}; do
  if curl -fsSL -m 4 -o /dev/null "$URL/" 2>/dev/null; then
    echo " ✓"
    break
  fi
  echo -n "."
  sleep 2
done

# Actualizar BASE_URL en index.html si cambió
if [ -f "index.html" ]; then
  echo "→ Actualizando BASE_URL en index.html..."
  # Reemplaza la línea del BASE_URL para que apunte al nuevo tunnel
  python3 - <<EOF
import re
path = "index.html"
with open(path) as f: content = f.read()
new_url = "$URL"
content = re.sub(
  r'const BASE_URL = "https://[^"]+";',
  f'const BASE_URL = "{new_url}";',
  content
)
with open(path, "w") as f: f.write(content)
print(f"  ✓ BASE_URL actualizado a {new_url}")
EOF
fi

echo ""
echo "=========================================================="
echo "  Demo NFC Etiexpress · listo"
echo "=========================================================="
echo "  Dashboard:      $URL/"
echo "  D'Aristi:       $URL/p/daristi.html?uid=04A8B2C9F1E380&c=001&sig=A7F2C9B36E1D4892"
echo "  Ki'Xocolatl:    $URL/p/kixocolatl.html?uid=04F13C2D8B9000&c=001&sig=9C81B42F5EA17D30"
echo "  Yaal-Kaab:      $URL/p/yaalkaab.html?uid=047B5E11A2C800&c=001&sig=3D9FE2841B6C5A77"
echo "  Mayajal:        $URL/p/mayajal.html?uid=043CF288DE7100&c=001&sig=5EA01C9743B28FE1"
echo "  Patito:         $URL/p/patito.html?uid=04B8E51A7C0080&c=001&sig=2CD9A5F4817B6E33"
echo ""
echo "  Logs:"
echo "    server  → $SERVER_LOG"
echo "    tunnel  → $TUNNEL_LOG"
echo "=========================================================="
echo ""
echo "  ⚠ Si la URL cambió respecto a la anterior, regraba los 5"
echo "    chips con la NFC writer (http://localhost:7402)."
