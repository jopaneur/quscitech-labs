"""
append_footer_to_notebooks.py
--------------------------------------------------
Appends a standardized DOI and copyright footer
to all Jupyter notebooks in the repository.
"""

import json, argparse, pathlib

FOOTER_MD = """
---

### 📘 Citation and DOI

If referencing this repository or its companion materials, please cite:

> **Wilson, J. (2025).** *Quantum AI Systems — Theory, Architecture, and Applications: Companion Labs (QuSciTech-Labs).*
> QuSciTech Press. Zenodo. [https://doi.org/10.5281/zenodo.17212825](https://doi.org/10.5281/zenodo.17212825)

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.17212825.svg)](https://doi.org/10.5281/zenodo.17212825)

© 2025 **Dr. Joe Wilson** — All Rights Reserved
**QuSciTech Press** | [www.quscitech.com](https://www.quscitech.com)
"""

def find_notebooks(root: pathlib.Path, patterns):
    """Find all .ipynb files recursively matching the patterns."""
    notebooks = []
    for pat in patterns or ["**/*.ipynb"]:
        for path in root.glob(pat):
            if path.is_dir():
                notebooks.extend(path.rglob("*.ipynb"))
            elif path.suffix == ".ipynb" and ".ipynb_checkpoints" not in str(path):
                notebooks.append(path)
    return notebooks

def has_footer(nb):
    for cell in nb.get("cells", []):
        if "zenodo.17212825" in "".join(cell.get("source", [])):
            return True
    return False

def append_footer(nb_path: pathlib.Path):
    with nb_path.open("r", encoding="utf-8") as f:
        nb = json.load(f)

    if has_footer(nb):
        print(f"✅ Already has footer → {nb_path}")
        return

    nb["cells"].append({
        "cell_type": "markdown",
        "metadata": {},
        "source": [FOOTER_MD]
    })

    with nb_path.open("w", encoding="utf-8") as f:
        json.dump(nb, f, indent=2, ensure_ascii=False)

    print(f"✅ Footer added → {nb_path}")

def main():
    parser = argparse.ArgumentParser(description="Append footer to notebooks.")
    parser.add_argument("--root", default=".", help="Project root directory")
    parser.add_argument("--include", nargs="*", default=["**/*.ipynb"], help="Patterns to include")
    parser.add_argument("--dry-run", action="store_true", help="List notebooks without modifying")
    args = parser.parse_args()

    root = pathlib.Path(args.root).resolve()
    notebooks = find_notebooks(root, args.include)

    print(f"🔍 Found {len(notebooks)} notebook(s)")
    if args.dry_run:
        for nb in notebooks:
            print(f"Would process: {nb.relative_to(root)}")
    else:
        for nb in notebooks:
            append_footer(nb)

if __name__ == "__main__":
    main()

