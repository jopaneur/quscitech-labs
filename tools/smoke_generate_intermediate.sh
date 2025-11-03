#!/usr/bin/env bash
set -euo pipefail

ROOT="public/labs/Intermediate_Labs"
STAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

LABS=(
  "qais-quantum-kernel-svm-vs-logregression-lab"
  "qais-zz-expectation-scan-lab"
  "qais-BB84-QKD-lab"
  "qais-fidelity-trace-distance-lab"
  "qais-entanglement-tamper-check-lab"
  "qais-VQE-Toy-Minimization-lab"
)

echo "→ Generating tiny CSV/PNG smoke artifacts for Intermediate labs… (UTC ${STAMP})"
for L in "${LABS[@]}"; do
  BASE="${ROOT}/${L}/resources"
  DATA="${BASE}/assets/data"
  IMGS="${BASE}/assets/images"
  HTML="${BASE}/html"

  mkdir -p "${DATA}" "${IMGS}" "${HTML}"

  # 1) CSV (tiny)
  CSV="${DATA}/smoke_${L}.csv"
  cat > "${CSV}" <<CSV
x,y,stamp,lab
0,0,"${STAMP}","${L}"
1,1,"${STAMP}","${L}"
2,4,"${STAMP}","${L}"
3,9,"${STAMP}","${L}"
CSV

  # 2) PNG (minimal matplotlib)
  PY=$(cat <<'PYCODE'
import sys, matplotlib
import matplotlib.pyplot as plt
x=[0,1,2,3]; y=[0,1,4,9]
plt.plot(x,y, marker='o')
plt.title(sys.argv[1])
plt.xlabel('x'); plt.ylabel('y')
plt.tight_layout()
plt.savefig(sys.argv[2], dpi=120)
PYCODE
)
  IMG="${IMGS}/smoke_${L}.png"
  python - <<PY "${L}" "${IMG}"
${PY}
PY

  # 3) Tiny HTML
  cat > "${HTML}/smoke_${L}.html" <<HTML
<!doctype html><meta charset="utf-8">
<title>${L} — Smoke</title>
<h1>${L} — Smoke</h1>
<p>Generated: ${STAMP}</p>
<ul>
  <li>CSV: assets/data/$(basename "${CSV}")</li>
  <li>PNG: assets/images/$(basename "${IMG}")</li>
</ul>
HTML

  echo "   • ${L} → OK  (${CSV##*/}, ${IMG##*/})"
done

echo "✓ Intermediate smoke artifacts generated."
