#!/usr/bin/env python
"""
Generate real SVG QR codes for QuSciTech Labs access.

Outputs:
  public/labs/assets/qr-labs-portal.svg
  public/labs/assets/qr-labs-e1.svg
  public/labs/assets/qr-labs-e2.svg
  public/labs/assets/qr-labs-e3.svg
  public/labs/assets/qr-labs-doi.svg
"""

from pathlib import Path

import qrcode
from qrcode.image.svg import SvgImage


# --- Configure paths -------------------------------------------------------

REPO_ROOT = Path(__file__).resolve().parents[1]
ASSETS_DIR = REPO_ROOT / "public" / "labs" / "assets"
ASSETS_DIR.mkdir(parents=True, exist_ok=True)

# --- URLs encoded into each QR ---------------------------------------------

QR_TARGETS = {
    # Labs portal (track overview E.1 / E.2 / E.3)
    "qr-labs-portal.svg": "https://quscitech.com/instructors/QST-INST-2025/resources/labs/",

    # Beginner / Intermediate / Advanced track landing pages
    "qr-labs-e1.svg": "https://quscitech.com/instructors/QST-INST-2025/resources/labs/e1/",
    "qr-labs-e2.svg": "https://quscitech.com/instructors/QST-INST-2025/resources/labs/e2/",
    "qr-labs-e3.svg": "https://quscitech.com/instructors/QST-INST-2025/resources/labs/e3/",

    # Concept DOI for the full lab collection
    "qr-labs-doi.svg": "https://doi.org/10.5281/zenodo.17212825",
}


# --- Generator -------------------------------------------------------------

def generate_qr_svgs() -> None:
    print(f"Writing QR SVGs into: {ASSETS_DIR}")
    for filename, url in QR_TARGETS.items():
        out_path = ASSETS_DIR / filename

        img = qrcode.make(
            url,
            image_factory=SvgImage,
            box_size=10,
            border=4,
        )

        with out_path.open("wb") as f:
            img.save(f)

        print(f"  • {filename}  →  {url}")

    print("\nDone. Commit these SVGs and push to GitHub to publish them.")


if __name__ == "__main__":
    generate_qr_svgs()
