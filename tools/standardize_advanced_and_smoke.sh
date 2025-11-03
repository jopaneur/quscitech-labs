#!/usr/bin/env bash
set -euo pipefail

ROOT="public/labs/Advanced_Labs"
STAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/advanced_generate_report.txt"

mkdir -p "${LOG_DIR}"

# Advanced labs (as seen in your verify output)
LABS=(
  "qais-bloch-trajectories-lab"
  "qais-case-study-qalis-vs-crqc-llm-lab"
  "qais-cshs-correlation-sweep-lab"
  "qais-density-matrix-encoding-metricies-lab"
  "qais-grover-success-vs-noise"
  "qais-hybrid-pipeline-quantum-kernel-svm-lab"
  "qais-tiny-vqc-vs-logregression-lab"
)

{
  echo "============================================================"
  echo "QuSciTech Labs — Advanced README + Smoke Artifact Pass"
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

    # Ensure Option A folders exist
    mkdir -p "${DATA}" "${IMGS}" "${HTML}" \
             "${BASE}/assets/code" "${BASE}/assets/docs" \
             "${BASE}/notebooks" "${BASE}/tests"

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

    # 5) Seed lab resources README if missing (optional, keeps parity)
    STD_README="${BASE}/README_Lab_Standard.md"
    if [[ ! -f "${STD_README}" ]]; then
      cat > "${STD_README}" <<'MD'
# Lab Resources (Option A, Public)
This lab follows the QuSciTech public layout:
- `assets/data` → CSV/JSON/NPY or generated datasets
- `assets/images` → PNG/SVG plots
- `assets/code` → export/plot helpers
- `assets/docs` → lab-specific notes/citations
- `notebooks` → .ipynb sources (already customized; not auto-generated)
- `html` → rendered notebook exports
- `tests/hello-ci.html` → tiny smoke page for CI
MD
      echo "   - wrote:   README_Lab_Standard.md"
    fi

    # 6) Minimal lab-level smoke page (idempotent)
    TEST_HTML="${BASE}/tests/hello-ci.html"
    if [[ ! -f "${TEST_HTML}" ]]; then
      cat > "${TEST_HTML}" <<'HTML'
<!doctype html><meta charset="utf-8">
<title>QuSciTech Lab Smoke</title>
<h1>hello-ci ✅</h1>
<p>This is a lab-level smoke page under resources/tests/.</p>
HTML
      echo "   - wrote:   tests/hello-ci.html"
    fi

    echo
  done

  echo "✓ Completed README + smoke generation for Advanced labs."
  echo "============================================================"
} | tee "${LOG_FILE}"

echo "Log written to: ${LOG_FILE}"
