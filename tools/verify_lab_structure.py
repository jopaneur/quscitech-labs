#!/usr/bin/env python3
"""
QuSciTech Public Labs Structure Validator (Option A layout)

Enforces:
  - resources/assets/data   (data lives here)
  - resources/images        (images live here)

Warns (does not fail) if it sees legacy/alternate paths like resources/data.
"""

from pathlib import Path
import sys

REPO_ROOT = Path(__file__).resolve().parents[1]  # repo root assumed: tools/...
LABS_ROOT = REPO_ROOT / "public" / "labs"

# >>> Option A: current layout
REQUIRED_DIRS = [
    "resources/assets/data",   # data here (required)
    "resources/images",        # images here (required)
]

# Optional/legacy dirs we tolerate but warn about if present/misused
TOLERATED_ALT_DIRS = [
    "resources/data",              # legacy data
    "resources/assets/images",     # alt images
]

def list_lab_dirs():
    if not LABS_ROOT.exists():
        print(f"⚠️  Labs root not found: {LABS_ROOT}")
        return []
    # any directory under public/labs/*/* considered a lab (Beginner/Intermediate/Advanced)
    labs = []
    for tier in LABS_ROOT.iterdir():
        if not tier.is_dir():
            continue
        for lab in tier.iterdir():
            if lab.is_dir():
                labs.append(lab)
    return sorted(labs)

def validate_lab(lab: Path):
    missing = []
    warnings = []
    notes = []

    # Required dirs (Option A)
    for rel in REQUIRED_DIRS:
        if not (lab / rel).is_dir():
            missing.append(rel)

    # Soft warnings for alternate/legacy
    for rel in TOLERATED_ALT_DIRS:
        if (lab / rel).is_dir():
            warnings.append(f"Legacy/alternate present: {rel} (kept for compatibility)")

    # Gentle nudge if CSVs/images are in unexpected places
    # Scan a few common spots and suggest the canonical Option A locations
    assets_data = lab / "resources" / "assets" / "data"
    legacy_data = lab / "resources" / "data"
    images_dir = lab / "resources" / "images"
    alt_images = lab / "resources" / "assets" / "images"

    # CSVs in legacy data?
    if legacy_data.is_dir():
        csvs = list(legacy_data.glob("*.csv"))
        if csvs:
            warnings.append("Found CSVs in resources/data — Option A expects resources/assets/data.")

    # CSVs in assets/data fine; if none, note
    if assets_data.is_dir():
        if not any(assets_data.glob("*.csv")):
            notes.append("No CSVs found in resources/assets/data (ok if not needed).")

    # Images check
    if images_dir.is_dir():
        if not any(images_dir.glob("*.png")) and not any(images_dir.glob("*.jpg")):
            notes.append("No images in resources/images (ok if not generated yet).")
    elif alt_images.is_dir():
        warnings.append("Images found under resources/assets/images — Option A expects resources/images.")

    return missing, warnings, notes

def main():
    labs = list_lab_dirs()
    if not labs:
        print("No labs found under public/labs.")
        sys.exit(0)

    any_fail = False
    print("→ Running QuSciTech Public Lab structure verification (Option A)…")
    print(f"Root: {LABS_ROOT}\n")

    for lab in labs:
        rel = lab.relative_to(REPO_ROOT)
        print(f"🔎 Validating: {rel}")
        missing, warnings, notes = validate_lab(lab)
        if missing:
            any_fail = True
            print("❌ FAIL")
            print("   - Missing required folders:")
            for m in missing:
                print(f"  - {m}")
        else:
            print("✅ Structure OK")

        if warnings:
            print("⚠️  Warnings:")
            for w in warnings:
                print(f"   - {w}")
        if notes:
            print("ℹ️  Notes:")
            for n in notes:
                print(f"   - {n}")
        print()

    if any_fail:
        print("Some checks failed. See ❌ items above.\n")
        sys.exit(1)

    print("All checks passed.\n")
    sys.exit(0)

if __name__ == "__main__":
    main()
