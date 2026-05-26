#!/usr/bin/env bash
# Deploy permanente a GitHub Pages.
# Corre esto si quieres una URL fija que NO dependa del tunnel Cloudflare.
# Después de correrlo: regraba los 5 chips con las URLs nuevas (van a usar el dominio github.io).

set -euo pipefail

PROJECT_DIR="$HOME/Trabajo/Documentos/nfc-etiexpress-demo"
REPO_NAME="nfc-etiexpress-demo"

cd "$PROJECT_DIR"

# Verifica gh CLI
if ! command -v gh &>/dev/null; then
  echo "✗ gh CLI no instalada. Instala con: brew install gh"
  exit 1
fi
if ! gh auth status &>/dev/null; then
  echo "✗ gh no autenticada. Corre: gh auth login"
  exit 1
fi

# Crea repo público y push (si no existe)
if ! gh repo view "$REPO_NAME" &>/dev/null; then
  echo "→ Creando repo público $REPO_NAME..."
  gh repo create "$REPO_NAME" --public --source=. --push \
    --description "Demo NFC NTAG 424 DNA para Etiexpress · 5 productos yucatecos con landings firmadas (datos demo)"
else
  echo "→ Repo ya existe. Pushing cambios..."
  git push origin main 2>/dev/null || git push origin master 2>/dev/null || true
fi

# Activa GitHub Pages
USER=$(gh api user --jq .login)
echo "→ Activando GitHub Pages..."
gh api -X POST "repos/$USER/$REPO_NAME/pages" \
  -f "source[branch]=main" -f "source[path]=/" 2>/dev/null || \
gh api -X POST "repos/$USER/$REPO_NAME/pages" \
  -f "source[branch]=master" -f "source[path]=/" 2>/dev/null || \
  echo "  (Pages ya estaba activado, OK)"

URL="https://$USER.github.io/$REPO_NAME"

# Actualiza BASE_URL en index.html
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

git add index.html
git commit -m "Update BASE_URL to GitHub Pages domain" --allow-empty
git push

echo ""
echo "=========================================================="
echo "  Deploy permanente · GitHub Pages"
echo "=========================================================="
echo "  Dashboard:      $URL/"
echo "  D'Aristi:       $URL/p/daristi.html?uid=04A8B2C9F1E380&c=001&sig=A7F2C9B36E1D4892"
echo "  Ki'Xocolatl:    $URL/p/kixocolatl.html?uid=04F13C2D8B9000&c=001&sig=9C81B42F5EA17D30"
echo "  Yaal-Kaab:      $URL/p/yaalkaab.html?uid=047B5E11A2C800&c=001&sig=3D9FE2841B6C5A77"
echo "  Mayajal:        $URL/p/mayajal.html?uid=043CF288DE7100&c=001&sig=5EA01C9743B28FE1"
echo "  Patito:         $URL/p/patito.html?uid=04B8E51A7C0080&c=001&sig=2CD9A5F4817B6E33"
echo "=========================================================="
echo ""
echo "  ⚠ Pages tarda 1–3 min en estar live después del primer deploy."
echo "  ⚠ Regraba los 5 chips con estas URLs nuevas."
