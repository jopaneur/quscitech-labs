#!/usr/bin/env bash
set -euo pipefail

ROOT="public/labs/Intermediate_Labs"
LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/intermediate_scaffold_report.txt"
STAMP="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

# Ensure log dir
mkdir -p "${LOG_DIR}"

# Labs to scaffold (mirror Beginner model)
LABS=(
  "qais-quantum-kernel-svm-vs-logregression-lab"
  "qais-zz-expectation-scan-lab"
  "qais-BB84-QKD-lab"
  "qais-fidelity-trace-distance-lab"
  "qais-entanglement-tamper-check-lab"
  "qais-VQE-Toy-Minimization-lab"
)

created_count=0
skipped_count=0
created_list=()
skipped_list=()

{
  echo "============================================================"
  echo "QuSciTech Labs — Intermediate Scaffold (Option A)"
  echo "UTC: ${STAMP}"
  echo "Repo root: $(pwd)"
  echo "Target root: ${ROOT}"
  echo "============================================================"
  echo

  echo "→ Initializing Intermediate labs scaffold (Option A)…"
  for L in "${LABS[@]}"; do
    BASE="${ROOT}/${L}/resources"
    echo "   • ${L}"

    # Track whether this lab is new or already had the scaffold
    new_any=false

    # Core folders (Option A)
    for d in \
      "assets/data" "assets/images" "assets/code" "assets/docs" \
      "notebooks" "html" "tests"
    do
      if [[ ! -d "${BASE}/${d}" ]]; then
        mkdir -p "${BASE}/${d}"
        new_any=true
        printf "     - created: %s\n" "${BASE}/${d}"
      fi
    done

    # Keep empty dirs under version control
    for keep in "assets/data" "assets/images" "assets/code" "assets/docs" "notebooks" "html"; do
      touch "${BASE}/${keep}/.gitkeep"
    done

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
      new_any=true
      echo "     - created: ${STD_README}"
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
      new_any=true
      echo "     - created: ${TEST_HTML}"
    fi

    if [[ "${new_any}" == "true" ]]; then
      created_count=$((created_count+1))
      created_list+=("${L}")
    else
      skipped_count=$((skipped_count+1))
      skipped_list+=("${L}")
      echo "     - unchanged (already standardized)"
    fi
  done

  echo
  echo "✓ Intermediate scaffold complete."
  echo
  echo "------------------------------------------------------------"
  echo "Summary:"
  echo "  Created/updated: ${created_count}"
  echo "  Skipped (already OK): ${skipped_count}"
  if (( ${#created_list[@]} )); then
    echo "  ▶ Created/Updated labs:"
    for x in "${created_list[@]}"; do echo "    - ${x}"; done
  fi
  if (( ${#skipped_list[@]} )); then
    echo "  ▶ Skipped labs:"
    for x in "${skipped_list[@]}"; do echo "    - ${x}"; done
  fi

  echo "------------------------------------------------------------"
  echo "Post-run tree (Intermediate_Labs only, depth 3 for brevity):"
  # 'tree' may not exist on all runners; fall back to find
  if command -v tree >/dev/null 2>&1; then
    tree -L 3 "${ROOT}" || true
  else
    find "${ROOT}" -maxdepth 3 -type d | sort
  fi
  echo "============================================================"
} | tee "${LOG_FILE}"

echo "Log written to: ${LOG_FILE}"
