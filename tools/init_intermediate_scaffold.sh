#!/usr/bin/env bash
set -euo pipefail

ROOT="public/labs/Intermediate_Labs"

# List of Intermediate labs to (re)scaffold
LABS=(
  "qais-quantum-kernel-svm-vs-logregression-lab"
  "qais-zz-expectation-scan-lab"
  "qais-BB84-QKD-lab"
  "qais-fidelity-trace-distance-lab"
  "qais-entanglement-tamper-check-lab"
  "qais-VQE-Toy-Minimization-lab"
)

echo "→ Initializing Intermediate labs scaffold (Option A)…"
for L in "${LABS[@]}"; do
  BASE="${ROOT}/${L}/resources"
  echo "   • ${L}"

  # Core folders (Option A)
  mkdir -p "${BASE}/assets/data" \
           "${BASE}/assets/images" \
           "${BASE}/assets/code" \
           "${BASE}/assets/docs" \
           "${BASE}/notebooks" \
           "${BASE}/html" \
           "${BASE}/tests"

  # Keep empty dirs under version control
  touch "${BASE}/assets/data/.gitkeep" \
        "${BASE}/assets/images/.gitkeep" \
        "${BASE}/assets/code/.gitkeep" \
        "${BASE}/assets/docs/.gitkeep" \
        "${BASE}/notebooks/.gitkeep" \
        "${BASE}/html/.gitkeep"

  # Lab standard README (idempotent seed)
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
  fi

  # Minimal smoke test page (idempotent)
  TEST_HTML="${BASE}/tests/hello-ci.html"
  if [[ ! -f "${TEST_HTML}" ]]; then
    cat > "${TEST_HTML}" <<'HTML'
<!doctype html><meta charset="utf-8">
<title>QuSciTech Lab Smoke</title>
<h1>hello-ci ✅</h1>
<p>This is a lab-level smoke page under resources/tests/.</p>
HTML
  fi
done

echo "✓ Intermediate scaffold complete."
