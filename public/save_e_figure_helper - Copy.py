"""
save_e_figure_helper.py
--------------------------------------------------
Provides a helper for saving lab figures
with standardized filenames and metadata.
"""

import os
import matplotlib.pyplot as plt

def save_e_figure(fig_label, fname, subdir="Beginner_Labs/figures", fig=None, ax=None):
    """Save a figure with standardized name and label."""
    os.makedirs(subdir, exist_ok=True)
    if fig is None:
        fig = plt.gcf()
    if ax is None and fig.axes:
        ax = fig.axes[0]

    if ax and not ax.get_title().startswith(fig_label):
        ax.set_title(f"{fig_label} — {ax.get_title()}".strip(" —"))

    path = os.path.join(subdir, fname)
    fig.tight_layout()
    fig.savefig(path, dpi=160)
    print(f"💾 Saved figure → {path}")
