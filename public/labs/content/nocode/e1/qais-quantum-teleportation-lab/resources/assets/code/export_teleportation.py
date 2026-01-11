from pathlib import Path
import csv
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / "assets" / "data"
IMGS = ROOT / "assets" / "images"
DATA.mkdir(parents=True, exist_ok=True)
IMGS.mkdir(parents=True, exist_ok=True)

csv_path = DATA / "teleportation_fidelity.csv"
png_path = IMGS / "teleportation_fidelity.png"

# Tiny synthetic “before vs after teleportation” fidelity demo
rows = [("trial","input_state_label","fidelity")]
labels = ["|0⟩","|1⟩","|+⟩","|−⟩","|i⟩","|−i⟩"]
vals   = [0.995, 0.991, 0.988, 0.989, 0.987, 0.990]
for i, (lbl, f) in enumerate(zip(labels, vals), 1):
    rows.append((i, lbl, f))

with open(csv_path, "w", newline="", encoding="utf-8") as f:
    csv.writer(f).writerows(rows)

plt.figure()
plt.title("Quantum Teleportation — Output Fidelity (toy)")
plt.plot(range(1, len(vals)+1), vals, marker="o")
plt.xticks(range(1, len(vals)+1), labels)
plt.ylim(0.95, 1.0)
plt.ylabel("Fidelity")
plt.tight_layout()
plt.savefig(png_path, dpi=160)
plt.close()

print(f"✅ Wrote: {csv_path}")
print(f"✅ Wrote: {png_path}")
