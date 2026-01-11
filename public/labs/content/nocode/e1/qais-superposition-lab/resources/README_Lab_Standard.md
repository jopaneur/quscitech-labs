# 🧠 QAIS Public Lab Resource Standard  
### (QuSciTech Labs — Verified Open Resources)

---

## 🧩 Lab Overview
**Lab Title:** `qais-<topic>-lab`  
**Example:** `qais-bell-state-correlated-outcomes-lab`  

Each public QAIS lab includes structured assets for reproducibility, educational clarity, and automation support.  
This README defines the **standard folder structure**, **execution instructions**, and **expectations** for contributors.

---

## 📂 Folder Structure

resources/
├── assets/
│ ├── code/ # Python or JS source files (read-only scripts)
│ ├── data/ # Reference input data (seed or theory CSVs)
│ ├── docs/ # Supporting equations, paper excerpts, or derivations
│ └── images/ # Supplemental figures or diagrams (non-generated)
├── data/ # Generated CSV datasets (output only)
├── images/ # Generated visualizations / plots (output only)
├── html/ # Optional static exports (HTML reports or dashboards)
└── notebooks/ # Jupyter notebooks (.ipynb) for the same lab

---


> **Convention:**  
> Only `/resources/data` and `/resources/images` contain generated files.  
> `/resources/assets/*` is static — it never receives new outputs.

---

## ⚙️ Environment Setup

### 1️⃣ Install Dependencies
Run once in **Git Bash**, **PowerShell**, or your IDE terminal:

```bash
py -3.13 -m pip install --upgrade pip matplotlib numpy

---

Verify the environment:

py -3.13 -c "import matplotlib, numpy; print(matplotlib.__version__, numpy.__version__)"

Expected output example:

3.10.7 1.26.4

If either package is missing, re-run the install command above.

Running the Export / Plot Script
Navigate to your lab’s assets/code folder:

Example for this lab:

cd "G:/My Drive/GitHub/quscitech-labs/public/labs/Beginner_Labs/qais-bell-state-correlated-outcomes-lab/resources/assets/code"

Then execute:

py -3.13 export_bell_plot.py

Expected terminal output:

✅ Saved plot: .../resources/images/bell_correlation.png
ℹ️ Data source: theoretical (auto-generated CSV)

Output Validation

After running the script:

Type	File	Destination	Example
Plot	.png	/resources/images/	bell_correlation.png
Data	.csv	/resources/data/	bell_correlation.csv

Confirm visually in Explorer or run:

find . -maxdepth 4 -name "bell_correlation.*" -print

---

## Troubleshooting

Problem	Cause	Fix
ModuleNotFoundError	Missing package	Run pip install matplotlib numpy
No output files	Wrong working directory	Always cd into /assets/code/
CSV duplicates	Old resources/data/ copy	Delete extra CSV from /assets/data/
PNG not visible	File sync lag	Press F5 in Explorer or wait for Drive to sync

---

Git Commit Guide

When satisfied with your generated results:

git add resources/data resources/images
git commit -m "lab(<topic>): add generated CSV + plot"
git push

---

**Notes for Contributors**

Maintain all relative paths — no absolute drive letters in code.

Use consistent Python formatting (PEP8).

Include console log confirmation (✅, ℹ️) in each script.

Do not overwrite existing /assets/ files unless explicitly updating a seed dataset or figure.

---

✅ Summary

This lab is QAIS-compliant when:

/resources/assets/ holds only input materials.

/resources/data and /resources/images hold clean, verified outputs.

The export script runs successfully via py -3.13 <script>.py.

Git commits include new results without redundancy.

Maintained under QuSciTech Public Labs Standardization Initiative
Version: 1.0 • Framework: QAIS–CRQC–LLM (Public Branch)
© 2025 QuSciTech Press — All Rights Reserved


---

### ✅ What this achieves
- Every lab contributor (student or dev) can run one simple command without setup confusion.  
- Outputs always land in the correct folders.  
- You get clean CI/CD logs showing each artifact’s creation path.  
- It’s fully compatible with GitHub Actions and Drive sync.
