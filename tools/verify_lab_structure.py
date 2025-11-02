#!/usr/bin/env python3
"""
QuSciTech Public Labs Structure Validator (Final Option A Layout)

Validates that every public lab includes:
  - resources/assets/data
  - resources/assets/images

Notes:
  • Other legacy folders (resources/data or resources/images) are tolerated
    but not required.
  • Meant for pre-commit integration under tools/verify_lab_structure.py
"""

from pathlib import Path
import sys

REPO_ROOT = Path(__file__).resolve().parents[1]  # repo root (tools/..)
LABS_ROOT = REPO_ROOT / "public" / "labs"

# --- Option A required subpaths ---
REQUIRED_DIRS = [
    "resources/assets/data",
    "resources/assets/images",
]

# Tolerated but not required (legacy/alternate)
TOLERATED_ALT_DIRS = [
    "resources/data",
    "resources/images",
]

def list_lab_dirs():
    """Return all lab directories under public/labs/*/*, skipping backups/hidden."""
    labs = []
    if not LABS_ROOT.exists():
        print(f"⚠️ Labs root not found: {LABS_ROOT}")
        return labs
    for tier in LABS_ROOT.iterdir():
        if not tier.is_dir():
            continue
        for lab in tier.iterdir():
            if not lab.is_dir():
                continue
            name = lab.name
            # Skip backup/hidden or temp labs
            if name.startswith("_") or name.lower() in {"backup", ".backup"}:
                continue
            labs.append(lab)
    return sorted(labs)


def validate_lab(lab: Path):
    """Check required and optional folders inside one lab."""
    missing, warnings, notes = [], [], []

    # required Option A folders
    for rel in REQUIRED_DIRS:
        if not (lab / rel).is_dir():
            missing.append(rel)

    # optional tolerated ones
    for rel in TOLERATED_ALT_DIRS:
        if (lab / rel).is_dir():
            warnings.append(f"Legacy folder present (ok): {rel}")

    # quick note if data/images empty
    for rel in REQUIRED_DIRS:
        folder = lab / rel
        if folder.is_dir() and not any(folder.iterdir()):
            notes.append(f"{rel} exists but empty.")

    return missing, warnings, notes

def main():
    labs = list_lab_dirs()
    if not labs:
        print("No labs found under public/labs.")
        sys.exit(0)

    print("→ Running QuSciTech Public Lab Structure Verification (Final Option A)")
    print(f"Root: {LABS_ROOT}\n")

    any_fail = False
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

    print("All checks passed successfully.\n")
    sys.exit(0)

if __name__ == "__main__":
    main()

