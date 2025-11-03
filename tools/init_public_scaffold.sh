#!/usr/bin/env bash
set -euo pipefail

ROOT="public/labs"
count_created=0
count_kept=0

echo "→ Ensuring resources/assets/{data,images} exist (tracked) for ALL labs…"
# Match Advanced_Labs, Intermediate_Labs, Beginner_Labs
while IFS= read -r -d '' resdir; do
  for leaf in data images; do
    target="$resdir/assets/$leaf"
    if [[ -d "$target" ]]; then
      # ensure it’s tracked
      if [[ ! -e "$target/.gitkeep" ]]; then
        : > "$target/.gitkeep"
        ((count_kept++))
      fi
    else
      mkdir -p "$target"
      : > "$target/.gitkeep"
      ((count_created++))
    fi
  done
done < <(find "$ROOT" -type d -path "*/resources" -print0)

echo "✓ Created missing folders: $count_created"
echo "✓ Ensured tracking with .gitkeep: $count_kept"
echo "Done."

