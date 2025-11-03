#!/usr/bin/env bash
set -euo pipefail

# Mirrors lab artifacts from the source-of-truth lab trees into the public web tree.
#
# Source of truth (per lab):
#   public/labs/<Tier>/<lab>/resources/assets/data/*.csv
#   public/labs/<Tier>/<lab>/resources/assets/images/*.png
#   public/labs/<Tier>/<lab>/resources/html/*.html          <-- NEW (HTML exports)
#
# Publish target (web tree in repo; CI deploys this to the VPS):
#   public_html/instructors/QST-INST-2025/resources/labs/<lab>/data/*.csv
#   public_html/instructors/QST-INST-2025/resources/labs/<lab>/images/*.png
#   public_html/instructors/QST-INST-2025/resources/labs/<lab>/html/*.html

LABS_ROOT="public/labs"
WEB_ROOT="public_html/instructors/QST-INST-2025/resources/labs"

copy_glob_if_any() {
  local pattern="$1" dest="$2"
  shopt -s nullglob
  local files=( $pattern )
  if (( ${#files[@]} > 0 )); then
    mkdir -p "$dest"
    # Use a loop to handle spaces in filenames safely
    for f in "${files[@]}"; do
      cp -f "$f" "$dest/"
    done
    echo "    • $(printf '%-6s' "$(basename "$dest")")  ←  $(dirname "$pattern")  (${#files[@]} files)"
  else
    echo "    • $(printf '%-6s' "$(basename "$dest")")  —  none to sync"
  fi
  shopt -u nullglob
}

sync_one_lab() {
  local lab_dir="$1"           # e.g., public/labs/Beginner_Labs/qais-superposition-lab
  local lab_name
  lab_name="$(basename "$lab_dir")"

  local src_assets="$lab_dir/resources/assets"
  local src_html="$lab_dir/resources/html"

  local dst_lab="$WEB_ROOT/$lab_name"
  local dst_data="$dst_lab/data"
  local dst_images="$dst_lab/images"
  local dst_html="$dst_lab/html"

  echo "— $lab_name"

  # CSV/JSON/etc.
  copy_glob_if_any "$src_assets/data/*" "$dst_data"
  # Images
  copy_glob_if_any "$src_assets/images/*" "$dst_images"
  # HTML exports (NEW)
  copy_glob_if_any "$src_html/*.html" "$dst_html"
}

echo "→ Syncing lab artifacts (data/images/html) into web tree:"
echo "  SRC: $LABS_ROOT/<Tier>/<lab>/resources/{assets,data,images,html}"
echo "  DST: $WEB_ROOT/<lab>/{data,images,html}"
echo

# Match all tiers
tiers=( "Beginner_Labs" "Intermediate_Labs" "Advanced_Labs" )
for tier in "${tiers[@]}"; do
  tier_dir="$LABS_ROOT/$tier"
  [[ -d "$tier_dir" ]] || continue
  while IFS= read -r -d '' lab; do
    sync_one_lab "$lab"
  done < <(find "$tier_dir" -maxdepth 1 -mindepth 1 -type d -print0)
done

echo
echo "✓ Done. Staged web tree is under: $WEB_ROOT"
