#!/usr/bin/env bash
set -euo pipefail

ROOT="public/labs"
created=0
ensured=0

echo "→ Ensuring resources/assets/{data,images} exist (tracked) for ALL labs…"

while IFS= read -r -d '' resdir; do
  for leaf in data images; do
    target="$resdir/assets/$leaf"

    # create the folder if missing
    if [[ ! -d "$target" ]]; then
      mkdir -p "$target"
      ((created++))
    fi

    # ensure Git tracks it (drop a tiny README if missing)
    if [[ ! -e "$target/README.md" ]]; then
      cat > "$target/README.md" <<'MD'
This folder holds generated artifacts for this lab.

- `assets/data/`   → CSV/JSON/NPY or small datasets exported by helper scripts/notebooks
- `assets/images/` → PNG/SVG figures exported by helper scripts/notebooks

These files are produced locally or in CI; do not store large binaries here.
MD
      ((ensured++))
    fi
  done
done < <(find "$ROOT" -type d -path "*/resources" -print0)

echo "✓ Created missing folders: $created"
echo "✓ Ensured tracking (added README.md): $ensured"
echo "Done."

