"""
repo_preflight_check.py
--------------------------------------------------
Preflight QA checker for quscitech-labs.
- Verifies notebook naming conventions
- Checks DOI footer presence
- Confirms figure-save consistency
"""

import json, pathlib, re

ROOT = pathlib.Path(".").resolve()
DOI_KEY = "zenodo.17212825"

# === 1. Naming check ===
def check_filenames():
    print("🔍 Checking notebook naming...")
    bad_names = []
    for nb in ROOT.rglob("*.ipynb"):
        if ".ipynb_checkpoints" in str(nb):
            continue
        if " " in nb.name or not re.search(r"E\d+_\d+_.+_NoCode\.ipynb$", nb.name):
            bad_names.append(nb)
    if bad_names:
        print("⚠️ Incorrect filenames:")
        for n in bad_names: print(f"   {n}")
    else:
        print("✅ All notebook filenames follow E#_#_Title_NoCode.ipynb")

# === 2. Footer presence check ===
def check_footers():
    print("🔍 Checking footer presence...")
    missing = []
    for nb in ROOT.rglob("*.ipynb"):
        if ".ipynb_checkpoints" in str(nb):
            continue
        text = json.loads(nb.read_text(encoding="utf-8"))
        if not any(DOI_KEY in "".join(c.get("source", [])) for c in text.get("cells", [])):
            missing.append(nb)
    if missing:
        print("⚠️ Missing footer in:")
        for m in missing: print(f"   {m}")
    else:
        print("✅ All notebooks contain DOI footer")

# === 3. Figure path check ===
def check_figure_paths():
    print("🔍 Checking figure paths...")
    figs = list(ROOT.rglob("*.png"))
    if not figs:
        print("⚠️ No figures found — verify save_e_figure() outputs.")
    else:
        print(f"✅ Found {len(figs)} saved figure(s).")

if __name__ == "__main__":
    print("🧩 QuSciTech-Labs Preflight Check")
    check_filenames()
    check_footers()
    check_figure_paths()
    print("✅ Preflight complete.")

