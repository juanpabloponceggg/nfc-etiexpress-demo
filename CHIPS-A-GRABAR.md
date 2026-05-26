# Chips a grabar — 5 productos demo

> **Dominio público PERMANENTE:** `https://nfc-etiexpress-demo.vercel.app`
> Hospedado en Vercel — vive para siempre, no depende de tu Mac.

---

## 🥃 Chip #1 — Casa D'Aristi · Xtabentún

**URL a grabar:**
```
https://nfc-etiexpress-demo.vercel.app/p/daristi?uid=04A8B2C9F1E380&c=001&sig=A7F2C9B36E1D4892
```

**Datos del chip:**
- `uid` — `04A8B2C9F1E380`
- `c` — `001`
- `sig` — `A7F2C9B36E1D4892`

**Caso de uso:** Anti-falsificación + storytelling + recompra DTC internacional.

**Lo que ve el cliente al tapear:** verificación auténtica, lote #43215, fecha de embotellado, leyenda maya, 3 cocteles maridados, CTA recompra desde Europa.

---

## 🍫 Chip #2 — Ki'Xocolatl · Tableta 72% Plantación Ticul

**URL a grabar:**
```
https://nfc-etiexpress-demo.vercel.app/p/kixocolatl?uid=04F13C2D8B9000&c=001&sig=9C81B42F5EA17D30
```

**Datos del chip:**
- `uid` — `04F13C2D8B9000`
- `c` — `001`
- `sig` — `9C81B42F5EA17D30`

**Caso de uso:** Traceability árbol → tableta + storytelling de origen.

**Lo que ve el cliente:** ficha del árbol #T-427, GPS de Ticul, agricultor Don Andrés Cab, medalla oro AVPA Paris 2021, ficha técnica de la tableta.

---

## 🍯 Chip #3 — Yaal-Kaab · Miel Melipona Xunán Kab

**URL a grabar:**
```
https://nfc-etiexpress-demo.vercel.app/p/yaalkaab?uid=047B5E11A2C800&c=001&sig=3D9FE2841B6C5A77
```

**Datos del chip:**
- `uid` — `047B5E11A2C800`
- `c` — `001`
- `sig` — `3D9FE2841B6C5A77`

**Caso de uso:** Caso social cooperativa + análisis HPLC anti-adulteración + Slow Food.

**Lo que ve el cliente:** Doña Teresita (productora), donación $2 MXN automática al fondo educativo, gráfica HPLC con composición real, contexto cultural Xunán Kab.

---

## 🧶 Chip #4 — Mayajal · Hamaca Auténtica de Tixkokob

**URL a grabar:**
```
https://nfc-etiexpress-demo.vercel.app/p/mayajal?uid=043CF288DE7100&c=001&sig=5EA01C9743B28FE1
```

**Datos del chip:**
- `uid` — `043CF288DE7100`
- `c` — `001`
- `sig` — `5EA01C9743B28FE1`

**Caso de uso:** Artesanía con DO en gestión + anti-falsificación china + caso social visceral.

**Lo que ve el cliente:** Doña Conchita Uc Pat (tejedora, 41 años de oficio), 87 horas de tejido, las 3 señales para identificar hamaca real vs telar chino, IG en gestión IMPI.

---

## 🍺 Chip #5 — Cervecería Patito · Lager Yucateca

**URL a grabar:**
```
https://nfc-etiexpress-demo.vercel.app/p/patito?uid=04B8E51A7C0080&c=001&sig=2CD9A5F4817B6E33
```

**Datos del chip:**
- `uid` — `04B8E51A7C0080`
- `c` — `001`
- `sig` — `2CD9A5F4817B6E33`

**Caso de uso:** FMCG bebidas + gamification loyalty 8 estilos + analytics off-trade.

**Lo que ve el cliente:** ficha técnica (ABV 4.5%, IBU 22, malta, lúpulo), Patito Collector Club con 1/8 badges desbloqueados, integración Untappd, canal de distribución (Chedraui Altabrisa).

**Bonus para JP en la demo:** abre el accordion "Esta lata fue distribuida en…" para mostrar a stakeholders el dato B2B de analytics off-trade.

---

## Cómo grabarlos (con la NFC writer local)

1. **Arrancar la NFC writer:** Si no está corriendo:
   ```bash
   cd ~/Trabajo/Documentos/nfc-writer
   nohup node server.js > /tmp/nfc-writer.log 2>&1 &
   disown
   ```
   Verifica abriendo http://localhost:7402 — pill verde "reader connected" si el ACR1252U está enchufado.

2. **Etiqueta físicamente cada chip** con masking tape escribiendo el slug:
   - Chip #1 → "DAR" (D'Aristi)
   - Chip #2 → "KIX" (Ki'Xocolatl)
   - Chip #3 → "YAA" (Yaal-Kaab)
   - Chip #4 → "HAM" (Mayajal hamaca)
   - Chip #5 → "PAT" (Patito)

3. **Para cada chip:**
   - Copia la URL completa de este documento (toda la línea).
   - Pégala en el prompt de http://localhost:7402.
   - Apoya el chip correspondiente sobre el lector ACR1252U.
   - Presiona ENTER.
   - Espera el `✓ verify OK` en la consola.
   - Despega el chip y pásalo al siguiente.

4. **Verifica con el iPhone:** pega tu celular a cada chip antes de la junta. Si el banner abre la URL correcta, está listo.

---

## ⚠ Importante

**Si ya grababas chips con URLs anteriores (trycloudflare.com o github.io), tienes que REGRABARLOS con estas URLs nuevas de Vercel.** Los chips no se actualizan automáticamente — graban lo que tenían cuando los pusiste sobre el lector.
