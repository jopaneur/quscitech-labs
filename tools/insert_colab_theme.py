#!/usr/bin/env python3
"""
Insert the Google Colab background-fix CSS cell into all NoCode notebooks.

Targets:
  public/labs/**/resources/notebooks/*_NoCode.ipynb

Safe behavior:
  - Will NOT duplicate the cell if it already exists.
  - Maintains notebook order and metadata.
  - Only modifies NoCode notebooks.
"""

import os
import json

# Root directory for public labs
ROOT = "public/labs"

# CSS injection code cell
CSS_CELL = {
    "cell_type": "code",
    "metadata": {},
    "source": [
        "from IPython.display import HTML\n\n",
        "HTML(\"\"\"\n",
        "<style>\n",
        "/* Restore standard Google Colab background */\n",
        "body, .notebook-container {\n",
        "    background-color: #f5f5f5 !important;\n",
        "}\n\n",
        ".colab-df-container {\n",
        "    background: white !important;\n",
        "}\n\n",
        "/* Optional: match Colab's input cell background */\n",
        ".cell {\n",
        "    background-color: #ffffff !important;\n",
        "}\n",
        "</style>\n",
        "\"\"\");"
    ],
    "outputs": [],
    "execution_count": None
}


def should_modify(fname):
    """Return True only for valid NoCode notebooks."""
    return (
        fname.endswith("_NoCode.ipynb")
        and os.path.isfile(fname)
        and "/.ipynb_checkpoints/" not in fname
    )


def inject_css_cell(nb_path):
    """Insert CSS cell at the top of the notebook if not already present."""
    print(f"→ Checking: {nb_path}")

    with open(nb_path, "r", encoding="utf-8") as f:
        nb = json.load(f)

    # Safety: ensure notebook has cells structure
    if "cells" not in nb or not isinstance(nb["cells"], list):
        print(f"  ⚠ Skipped (invalid notebook)")
        return

    # Check if CSS cell already exists
    for cell in nb["cells"]:
        if (
            cell.get("cell_type") == "code"
            and "HTML" in "".join(cell.get("source", []))
            and "background-color" in "".join(cell.get("source", []))
        ):
            print("  ✓ CSS cell already present — skipping")
            return

    # Insert at position 0
    nb["cells"].insert(0, CSS_CELL)
    print("  ✓ CSS cell inserted")

    # Write file back
    with open(nb_path, "w", encoding="utf-8") as f:
        json.dump(nb, f, indent=1, ensure_ascii=False)
    print("  ✓ Notebook updated\n")


def main():
    print("Scanning for NoCode notebooks…\n")

    for root, dirs, files in os.walk(ROOT):
        for file in files:
            fullpath = os.path.join(root, file)
            if should_modify(fullpath):
                inject_css_cell(fullpath)

    print("All notebooks processed.\n")


if __name__ == "__main__":
    main()
