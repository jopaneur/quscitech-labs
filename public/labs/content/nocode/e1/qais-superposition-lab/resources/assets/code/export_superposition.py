from pathlib import Path
import csv
import numpy as np
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / "assets" / "data"
IMGS = ROOT / "assets" / "images"
DATA.mkdir(parents=True, exist_ok=True)
IMGS.mkdir(parents=True, exist_ok=True)

csv_path = DATA / "superposition_probs.csv"
png_path = IMGS / "superposition_probs.png"

# Simple |+> state measurement statistics vs. artificial noise param
noise = np.linspace(0.0, 0.3, 21)
p0 = 0.5 + 0.5*noise*0   # stays ~0.5 in this toy demo
p1 = 1.0 - p0

with open(csv_path, "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["noise", "p0", "p1"])
    for n, a, b in zip(noise, p0, p1):
        w.writerow([float(n), float(a), float(b)])

plt.figure()
plt.title("Superposition |+⟩ — P(|0⟩), P(|1⟩)")
plt.plot(noise, p0, marker="o", label="P(|0⟩)")
plt.plot(noise, p1, marker="o", label="P(|1⟩)")
plt.xlabel("noise (arb.)")
plt.ylabel("Probability")
plt.ylim(0.0, 1.0)
plt.legend()
plt.tight_layout()
plt.savefig(png_path, dpi=160)
plt.close()

print(f"✅ Wrote: {csv_path}")
print(f"✅ Wrote: {png_path}")
