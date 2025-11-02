# export_bell_plot.py
# Bell-state correlated outcomes: CSV -> plot, with auto-fallback to theory
from __future__ import annotations
import csv
from pathlib import Path
from typing import List, Tuple

import numpy as np
import matplotlib.pyplot as plt

# --- Paths (relative to this script) -----------------------------------------
CODE_DIR = Path(__file__).resolve().parent
LAB_ROOT = CODE_DIR.parents[1]  # .../resources/assets
DATA_PATH = LAB_ROOT / "data" / "bell_correlation.csv"
IMG_DIR = LAB_ROOT / "images"
IMG_DIR.mkdir(parents=True, exist_ok=True)
PNG_OUT = IMG_DIR / "bell_correlation.png"

# --- Helpers -----------------------------------------------------------------
def read_csv_angles_corr(path: Path) -> List[Tuple[float, float]]:
    """Read angle_deg,correlation rows (ignoring comments/blank lines)."""
    # Try common encodings; fall back to binary sniff
    for enc in ("utf-8", "utf-8-sig", "cp1252", "latin-1"):
        try:
            with open(path, "r", encoding=enc, newline="") as f:
                rows = []
                reader = csv.DictReader(
                    (r for r in f if r.strip() and not r.lstrip().startswith("#"))
                )
                for row in reader:
                    a = float(row["angle_deg"])
                    c = float(row["correlation"])
                    rows.append((a, c))
                if rows:
                    return rows
        except FileNotFoundError:
            raise
        except Exception:
            continue
    # One last permissive attempt
    with open(path, "r", encoding="latin-1", errors="ignore") as f:
        rows = []
        reader = csv.DictReader(
            (r for r in f if r.strip() and not r.lstrip().startswith("#"))
        )
        for row in reader:
            a = float(row["angle_deg"])
            c = float(row["correlation"])
            rows.append((a, c))
        return rows

def generate_theoretical() -> List[Tuple[float, float]]:
    """S(θ) = −cos θ for θ ∈ [0°, 180°]; returns (angle_deg, correlation)."""
    angles_deg = np.linspace(0.0, 180.0, 181)
    angles_rad = np.deg2rad(angles_deg)
    corr = -np.cos(angles_rad)
    return list(zip(angles_deg.tolist(), corr.tolist()))

def write_csv(path: Path, rows: List[Tuple[float, float]]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w", encoding="utf-8", newline="") as f:
        f.write("# Auto-generated theoretical Bell correlation data\n")
        writer = csv.writer(f)
        writer.writerow(["angle_deg", "correlation"])
        writer.writerows(rows)

# --- Main --------------------------------------------------------------------
def main() -> None:
    # Try to load CSV; if missing/unreadable, fall back and write CSV
    try:
        rows = read_csv_angles_corr(DATA_PATH)
        source = f"CSV: {DATA_PATH.name}"
    except FileNotFoundError:
        rows = generate_theoretical()
        write_csv(DATA_PATH, rows)
        source = "theoretical (auto-generated CSV)"

    angles, corr = zip(*rows)

    plt.figure()
    plt.plot(angles, corr, linewidth=2, label="S(θ) = −cos θ")
    plt.xlabel("Relative analyzer angle θ (degrees)")
    plt.ylabel("Correlation S(θ)")
    plt.title("Bell State — Correlated Outcomes")
    plt.grid(True)
    plt.legend()
    plt.tight_layout()
    plt.savefig(PNG_OUT, dpi=180)
    print(f"✅ Saved plot: {PNG_OUT}")
    print(f"ℹ️ Data source: {source}")

if __name__ == "__main__":
    main()

