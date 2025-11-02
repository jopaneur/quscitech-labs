#!/bin/sh
set -euo pipefail

# ---- Config ----------------------------------------------------------
PY="py -3.13"

LABS_ROOT="public/labs/Beginner_Labs"
declare -A LABS
LABS[qais-superposition-lab]="export_superposition.py"
LABS[qais-angle-encoding-statevectors-lab]="export_angle_encoding.py"
LABS[qais-depth-noise-sensitivity-lab]="export_depth_noise.py"
LABS[qais-quantum-teleportation-lab]="export_teleportation.py"

# ---- Helpers ---------------------------------------------------------
mk_exporter() {
  local lab="$1"; local pyfile="$2"
  local CODE="$LABS_ROOT/$lab/resources/assets/code"
  local DATA="$LABS_ROOT/$lab/resources/assets/data"
  local IMGS="$LABS_ROOT/$lab/resources/assets/images"

  mkdir -p "$CODE" "$DATA" "$IMGS"

  if [[ -f "$CODE/$pyfile" ]]; then
    echo "  = exists    $CODE/$pyfile"
    return 0
  fi

  case "$lab" in
    qais-superposition-lab)
      cat > "$CODE/$pyfile" <<'PY'
from pathlib import Path
import csv, math
import numpy as np
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[2]  # .../resources
DATA = ROOT / "assets" / "data"
IMGS = ROOT / "assets" / "images"
DATA.mkdir(parents=True, exist_ok=True)
IMGS.mkdir(parents=True, exist_ok=True)

csv_path = DATA / "superposition_probs.csv"
png_path = IMGS / "superposition_probs.png"

# Single-qubit |+> and |-> measurement probabilities in Z-basis
thetas = np.linspace(0, 2*math.pi, 41)
rows = [("theta_rad","p0","p1")]
for t in thetas:
    a0 = math.cos(t/2)
    a1 = math.sin(t/2)
    p0 = a0*a0
    p1 = a1*a1
    rows.append((t, p0, p1))

with open(csv_path, "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f); w.writerows(rows)

plt.figure()
plt.title("Superposition: Probabilities vs θ")
plt.plot(thetas, [r[1] for r in rows[1:]], label="P(|0⟩)")
plt.plot(thetas, [r[2] for r in rows[1:]], label="P(|1⟩)")
plt.xlabel("θ (radians)"); plt.ylabel("Probability"); plt.ylim(0,1); plt.legend()
plt.tight_layout(); plt.savefig(png_path, dpi=160); plt.close()

print(f"✅ Wrote: {csv_path}")
print(f"✅ Wrote: {png_path}")
PY
      ;;
    qais-angle-encoding-statevectors-lab)
      cat > "$CODE/$pyfile" <<'PY'
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
    a0 = math.cos(t/2); a1 = math.sin(t/2)
    rows.append((t, a0, a1, a0*a0, a1*a1))

with open(csv_path, "w", newline="", encoding="utf-8") as f:
    csv.writer(f).writerows(rows)

plt.figure()
plt.title("Angle Encoding: Probabilities vs θ")
plt.plot(thetas, [r[3] for r in rows[1:]], label="P(|0⟩)")
plt.plot(thetas, [r[4] for r in rows[1:]], label="P(|1⟩)")
plt.xlabel("θ (radians)"); plt.ylabel("Probability"); plt.ylim(0,1); plt.legend()
plt.tight_layout(); plt.savefig(png_path, dpi=160); plt.close()

print(f"✅ Wrote: {csv_path}")
print(f"✅ Wrote: {png_path}")
PY
      ;;
    qais-depth-noise-sensitivity-lab)
      cat > "$CODE/$pyfile" <<'PY'
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

# Toy model: accuracy decays with depth and noise
depths = np.arange(1, 21)
noise = 0.02
rows = [("depth","noise","accuracy")]
for d in depths:
    acc = max(0.0, 1.0 - 0.03*d - noise*10 + random.uniform(-0.02,0.02))
    rows.append((d, noise, acc))

with open(csv_path, "w", newline="", encoding="utf-8") as f:
    csv.writer(f).writerows(rows)

plt.figure()
plt.title("Depth vs Accuracy (Toy Noise Model)")
plt.plot(depths, [r[2] for r in rows[1:]], marker="o")
plt.xlabel("Circuit Depth"); plt.ylabel("Accuracy"); plt.ylim(0,1)
plt.tight_layout(); plt.savefig(png_path, dpi=160); plt.close()

print(f"✅ Wrote: {csv_path}")
print(f"✅ Wrote: {png_path}")
PY
      ;;
    qais-quantum-teleportation-lab)
      cat > "$CODE/$pyfile" <<'PY'
from pathlib import Path
import csv
import numpy as np
import matplotlib.pyplot as plt

ROOT = Path(__file__).resolve().parents[2]
DATA = ROOT / "assets" / "data"
IMGS = ROOT / "assets" / "images"
DATA.mkdir(parents=True, exist_ok=True)
IMGS.mkdir(parents=True, exist_ok=True)

csv_path = DATA / "teleportation_fidelity.csv"
png_path = IMGS / "teleportation_fidelity.png"

# Toy fidelity table for demo (source vs received state overlap)
thetas = np.linspace(0, np.pi, 13)
rows = [("theta_rad","fidelity")]
for t in thetas:
    # simple smooth curve between 0.9 and ~0.99
    fid = 0.95 + 0.04*np.cos(t)
    rows.append((float(t), float(fid)))

with open(csv_path, "w", newline="", encoding="utf-8") as f:
    csv.writer(f).writerows(rows)

plt.figure()
plt.title("Quantum Teleportation (Toy) — Fidelity vs θ")
plt.plot(thetas, [r[1] for r in rows[1:]], marker="o")
plt.xlabel("θ (radians)"); plt.ylabel("Fidelity"); plt.ylim(0.85, 1.0)
plt.tight_layout(); plt.savefig(png_path, dpi=160); plt.close()

print(f"✅ Wrote: {csv_path}")
print(f"✅ Wrote: {png_path}")
PY
      ;;
    *)
      echo "  ! Unknown lab: $lab" ;;
  esac

  echo "  + wrote     $CODE/$pyfile"
}

run_exporter() {
  local lab="$1"; local pyfile="$2"
  local CODE="$LABS_ROOT/$lab/resources/assets/code"
  echo "  → running   $pyfile"
  $PY "$CODE/$pyfile"
}

check_artifacts() {
  local lab="$1"
  local DATA="$LABS_ROOT/$lab/resources/assets/data"
  local IMGS="$LABS_ROOT/$lab/resources/assets/images"

  local have_csv=$(ls "$DATA"/*.csv 2>/dev/null | wc -l | tr -d ' ')
  local have_png=$(ls "$IMGS"/*.png 2>/dev/null | wc -l | tr -d ' ')
  if [[ "$have_csv" -gt 0 && "$have_png" -gt 0 ]]; then
    echo "  ✓ artifacts OK ($have_csv CSV, $have_png PNG)"
  else
    echo "  ⚠ artifacts missing (CSV: $have_csv, PNG: $have_png)"
  fi
}

# ---- Main ------------------------------------------------------------
echo "→ Creating and running Beginner lab exporters…"
for lab in "${!LABS[@]}"; do
  echo
  echo "— $lab"
  if [[ ! -d "$LABS_ROOT/$lab" ]]; then
    echo "  ⚠ missing lab directory: $LABS_ROOT/$lab"
    continue
  fi
  mk_exporter "$lab" "${LABS[$lab]}"
  run_exporter "$lab" "${LABS[$lab]}"
  check_artifacts "$lab"
done

echo
echo "Done. You can verify with:"
echo "  py -3.13 tools/verify_lab_structure.py --all"

