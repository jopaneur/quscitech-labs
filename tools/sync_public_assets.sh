#!/usr/bin/env bash
set -euo pipefail

SRC_ROOT="public/labs"
DST_BASE="public_html/instructors/QST-INST-2025/resources/labs"

echo "→ Syncing exported lab assets into ${DST_BASE} …"
mkdir -p "${DST_BASE}"

# Copy artifacts from each lab's Option A assets tree to web mirror
while IFS= read -r -d '' resdir; do
  lab_dir="$(dirname "${resdir}")"
  lab_name="$(basename "${lab_dir}")"
  src_data="${resdir}/assets/data"
  src_imgs="${resdir}/assets/images"

  # Skip labs that don't have assets yet
  [[ -d "${src_data}" || -d "${src_imgs}" ]] || continue

  dst_lab="${DST_BASE}/${lab_name}"
  mkdir -p "${dst_lab}/data" "${dst_lab}/images"

  # Data: CSV/JSON/NPY
  if [[ -d "${src_data}" ]]; then
    find "${src_data}" -maxdepth 1 -type f \( -name "*.csv" -o -name "*.json" -o -name "*.npy" \) -print0 \
      | xargs -0 -I{} cp -f "{}" "${dst_lab}/data/" || true
  fi

  # Images: PNG/SVG
  if [[ -d "${src_imgs}" ]]; then
    find "${src_imgs}" -maxdepth 1 -type f \( -name "*.png" -o -name "*.svg" \) -print0 \
      | xargs -0 -I{} cp -f "{}" "${dst_lab}/images/" || true
  fi

  echo "  • ${lab_name} → ${dst_lab}"
done < <(find "${SRC_ROOT}" -type d -path "*/resources" -print0)

echo "✓ Sync complete."

