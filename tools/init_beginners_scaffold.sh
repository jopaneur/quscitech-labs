#!/bin/sh
# QuSciTech — Beginner Labs scaffold initializer (Option A)
# Creates missing resources/* scaffolding for selected Beginner labs.
# Idempotent: only creates files/folders that do NOT exist.
set -euo pipefail

# Repo-relative root (assumes you run from repo root)
ROOT="public/labs/Beginner_Labs"

# Target labs (do NOT include qais-bell-state-correlated-outcomes-lab here;
# it’s already complete per your last run)
LABS=(
  "qais-superposition-lab"
  "qais-angle-encoding-statevectors-lab"
  "qais-depth-noise-sensitivity-lab"
  "qais-quantum-teleportation-lab"
)

make_dir() {
  local d="$1"
  if [[ ! -d "$d" ]]; then
    mkdir -p "$d"
    echo "  + mkdir -p $d"
  else
    echo "  = exists    $d"
  fi
}

write_if_missing() {
  local path="$1"
  local content="$2"
  if [[ ! -f "$path" ]]; then
    printf "%s" "$content" > "$path"
    echo "  + wrote     $path"
  else
    echo "  = exists    $path"
  fi
}

readme_generic() {
cat <<'EOF'
# Resources

This folder contains standardized support assets for this lab.

**Layout**
- `assets/code/` — small helper/export scripts (optional)
- `assets/data/` — sample or generated CSV/JSON (do not commit secrets)
- `assets/docs/` — short design notes or lab-specific docs
- `assets/images/` — generated figures/artifacts for the lab
- `html/` — public-facing helpers (e.g., `hello-ci.html` for smoke tests)
- `tests/` — CI smoke tests and validator helpers (no secrets)

**Notes**
- Keep large/derived artifacts out of Git when possible.
- Notebooks (.ipynb) are managed separately and are not touched by this scaffold.
EOF
}

readme_assets_code() {
cat <<'EOF'
# assets/code

Small helper/export scripts for generating figures/data used by the lab.

- Keep scripts minimal and self-contained.
- Do not bake API keys or secrets into code or data.
- Prefer writing outputs into:
  - `../images/` for figures (PNG/SVG)
  - `../data/` for CSV/JSON
EOF
}

readme_assets_data() {
cat <<'EOF'
# assets/data

Put small CSV/JSON samples here if needed for development.
For CI and public distribution, prefer generating data on-demand in notebooks.
EOF
}

readme_assets_docs() {
cat <<'EOF'
# assets/docs

Short, lab-specific notes or diagrams that support the lab contents.
EOF
}

readme_assets_images() {
cat <<'EOF'
# assets/images

Generated figures used by the lab README or HTML preview.
Large binaries should generally be avoided in Git; generate them as needed.
EOF
}

readme_html() {
cat <<'EOF'
# resources/html

Public-facing helper pages for smoke tests or lightweight previews.
EOF
}

readme_tests() {
cat <<'EOF'
# resources/tests

CI smoke tests and simple checks that confirm required assets exist or can be generated.
EOF
}

placeholder_export_py() {
cat <<'EOF'
#!/usr/bin/env python3
"""
_placeholder_export.py
Minimal placeholder exporter for this lab. Safe to keep in repo; no heavy deps.
Outputs nothing by default—modify or replace per-lab needs.
"""
import sys
if __name__ == "__main__":
    print("Placeholder exporter — no action. OK.")
    sys.exit(0)
EOF
}

hello_ci_html() {
cat <<'EOF'
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>QuSciTech Lab Smoke Test</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>body{font-family:Arial,Helvetica,sans-serif;padding:24px}code{background:#f3f6fb;padding:2px 6px;border-radius:4px}</style>
</head>
<body>
  <h1>✅ QuSciTech Lab Smoke Test</h1>
  <p>This page confirms the lab’s <code>resources/html</code> is deployed and reachable.</p>
  <ul>
    <li>No secrets or dynamic data are exposed here.</li>
    <li>Use the pre-commit validator to ensure required folders exist.</li>
  </ul>
</body>
</html>
EOF
}

for lab in "${LABS[@]}"; do
  LABROOT="$ROOT/$lab"
  RES="$LABROOT/resources"

  if [[ ! -d "$LABROOT" ]]; then
    echo "⚠️  Skipping missing lab: $LABROOT"
    continue
  fi

  echo "— Processing: $LABROOT"

  # Core resources tree
  make_dir "$RES"
  write_if_missing "$RES/README_Lab_Standard.md" "$(readme_generic)"

  make_dir "$RES/assets/code"
  make_dir "$RES/assets/data"
  make_dir "$RES/assets/docs"
  make_dir "$RES/assets/images"
  write_if_missing "$RES/assets/code/README.md" "$(readme_assets_code)"
  write_if_missing "$RES/assets/data/README.md" "$(readme_assets_data)"
  write_if_missing "$RES/assets/docs/README.md" "$(readme_assets_docs)"
  write_if_missing "$RES/assets/images/README.md" "$(readme_assets_images)"
  write_if_missing "$RES/assets/code/_placeholder_export.py" "$(placeholder_export_py)"
  chmod +x "$RES/assets/code/_placeholder_export.py" || true

  make_dir "$RES/html"
  write_if_missing "$RES/html/README.md" "$(readme_html)"
  write_if_missing "$RES/html/hello-ci.html" "$(hello_ci_html)"

  make_dir "$RES/tests"
  write_if_missing "$RES/tests/README.md" "$(readme_tests)"

  echo "✓ Done: $lab"
  echo
done

echo "All requested Beginner lab scaffolds processed."
echo "You can now run:  py -3.13 tools/verify_lab_structure.py --all"

