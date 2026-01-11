from pathlib import Path
import csv, math, random
import numpy as np
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / "assets" / "data"
IMGS = ROOT / "assets" / "images"
DATA.mkdir(parents=True, exist_ok=True)
IMGS.mkdir(parents=True, exist_ok=True)

csv_path = DATA / "depth_noise_sweep.csv"
png_path = IMGS / "depth_noise_sweep.png"

depths = np.arange(1, 21)
noise = 0.02
rows = [("depth","noise","accuracy")]
for d in depths:
    acc = max(0.0, 1.0 - 0.03*d - noise*10 + random.uniform(-0.02,0.02))
    rows.append((int(d), float(noise), float(acc)))

with open(csv_path, "w", newline="", encoding="utf-8") as f:
    csv.writer(f).writerows(rows)

plt.figure()
plt.title("Depth vs Accuracy (Toy Noise Model)")
plt.plot(depths, [r[2] for r in rows[1:]], marker="o")
plt.xlabel("Circuit Depth"); plt.ylabel("Accuracy"); plt.ylim(0,1)
plt.tight_layout(); plt.savefig(png_path, dpi=160); plt.close()

print(f"✅ Wrote: {csv_path}")
print(f"✅ Wrote: {png_path}")

