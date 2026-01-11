# Tests — Bell-State Lab (Smoke)

Suggested lightweight checks (run locally or in CI):

1. **CSV present & valid**
   - File exists: `assets/data/bell_demo_counts.csv`
   - Columns: `outcome,count`
   - Outcomes ⊆ {00,01,10,11}

2. **Exporter writes fallback**
   - `python assets/code/export_bell_plot.py` creates
     `assets/images/bell_demo_counts.png` (non-zero size).

3. **HTML smoke**
   - `html/qais-bell-state-correlated-outcomes-lab.html` loads
     in a local static server (200) and the table renders.
