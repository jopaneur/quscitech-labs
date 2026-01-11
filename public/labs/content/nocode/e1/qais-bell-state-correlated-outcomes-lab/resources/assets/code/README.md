# Code — Bell-State (Correlated Outcomes) Lab

This folder holds runnable code used by the public HTML page and CI build steps.

- `bell_correlated_sim.js` — in-browser simulator that generates correlated measurement
  outcomes for the Bell state |Φ⁺⟩ and renders a table + canvas plot.
- `export_bell_plot.py` — offline exporter (no notebook needed). Reads the CSV in
  `../data/bell_demo_counts.csv` and writes a static PNG to `../images/bell_demo_counts.png`
  for no-JS fallback and screenshots.

> Execution
- Local: run the HTML file in `resources/html` (double-click) or host on a static server.
- Export PNG: `python export_bell_plot.py`
