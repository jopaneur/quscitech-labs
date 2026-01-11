from pathlib import Path
import csv, math
import numpy as np
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / "assets" / "data"
IMGS = ROOT / "assets" / "images"
DATA.mkdir(parents=True, exist_ok=True)
IMGS.mkdir(parents=True, exist_ok=True)

csv_path = DATA / "angles_demo.csv"
png_path = IMGS / "angles_demo.png"

thetas = np.linspace(0, 2*math.pi, 25)
rows = [("theta_rad","amp_0","amp_1","p0","p1")]
for t in thetas:
    a0 = math.cos(t/2)
    a1 = math.sin(t/2)
    rows.append((float(t), float(a0), float(a1), float(a0*a0), float(a1*a1)))

with open(csv_path, "w", newline="", encoding="utf-8") as f:
    csv.writer(f).writerows(rows)

plt.figure()
plt.title("Angle Encoding: Probabilities vs θ")
plt.plot(thetas, [r[3] for r in rows[1:]], label="P(|0⟩)")
plt.plot(thetas, [r[4] for r in rows[1:]], label="P(|1⟩)")
plt.xlabel("θ (radians)"); plt.ylabel("Probability"); plt.ylim(0, 1)
plt.legend(); plt.tight_layout(); plt.savefig(png_path, dpi=160); plt.close()

print(f"✅ Wrote: {csv_path}")
print(f"✅ Wrote: {png_path}")

