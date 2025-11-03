#!/usr/bin/env bash
set -euo pipefail

ROOT="public/labs/Intermediate_Labs"
STAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/intermediate_generate_report.txt"

mkdir -p "${LOG_DIR}"

LABS=(
  "qais-quantum-kernel-svm-vs-logregression-lab"
  "qais-zz-expectation-scan-lab"
  "qais-BB84-QKD-lab"
  "qais-fidelity-trace-distance-lab"
  "qais-entanglement-tamper-check-lab"
  "qais-VQE-Toy-Minimization-lab"
)

{
  echo "============================================================"
  echo "QuSciTech Labs — Intermediate README + Smoke Artifact Pass"
  echo "UTC: ${STAMP}"
  echo "Repo: $(pwd)"
  echo "Target: ${ROOT}"
  echo "============================================================"
  echo

  for L in "${LABS[@]}"; do
    BASE="${ROOT}/${L}/resources"
    DATA="${BASE}/assets/data"
    IMGS="${BASE}/assets/images"
    HTML="${BASE}/html"
    mkdir -p "${DATA}" "${IMGS}" "${HTML}"

    echo "→ ${L}"

    # 1) Ensure README.md in assets/data and assets/images
    if [[ ! -f "${DATA}/README.md" ]]; then
      echo "Data artifacts live here." > "${DATA}/README.md"
      echo "   - created: assets/data/README.md"
    else
      echo "   - exists:  assets/data/README.md"
    fi

    if [[ ! -f "${IMGS}/README.md" ]]; then
      echo "Generated plots live here." > "${IMGS}/README.md"
      echo "   - created: assets/images/README.md"
    else
      echo "   - exists:  assets/images/README.md"
    fi

    # 2) Generate CSV (tiny)
    CSV="${DATA}/smoke_${L}.csv"
    cat > "${CSV}" <<CSV
x,y,stamp,lab
0,0,"${STAMP}","${L}"
1,1,"${STAMP}","${L}"
2,4,"${STAMP}","${L}"
3,9,"${STAMP}","${L}"
CSV
    echo "   - wrote:   assets/data/$(basename "${CSV}")"

    # 3) Generate PNG with matplotlib (very small)
    PY=$(cat <<'PYCODE'
import sys
import matplotlib.pyplot as plt
title, out = sys.argv[1], sys.argv[2]
x=[0,1,2,3]; y=[0,1,4,9]
plt.plot(x,y, marker='o')
plt.title(title); plt.xlabel('x'); plt.ylabel('y'); plt.tight_layout()
plt.savefig(out, dpi=120)
PYCODE
)
    IMG="${IMGS}/smoke_${L}.png"
    python - <<PY "${L}" "${IMG}"
${PY}
PY
    echo "   - wrote:   assets/images/$(basename "${IMG}")"

    # 4) Tiny HTML for quick manual checks
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
    echo "   - wrote:   html/smoke_${L}.html"
    echo
  done

  echo "✓ Completed README + smoke generation for Intermediate labs."
  echo "============================================================"
} | tee "${LOG_FILE}"

echo "Log written to: ${LOG_FILE}"
