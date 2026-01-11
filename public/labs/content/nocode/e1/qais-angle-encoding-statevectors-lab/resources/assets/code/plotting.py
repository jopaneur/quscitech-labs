"""
plotting.py — Minimal Bloch Sphere plotting helpers for QAIS labs.
"""
import matplotlib.pyplot as plt
import numpy as np

def plot_bloch_angles(angle_list):
    """Plot cos(θ) vs sin(θ) for a list of angles."""
    cos_vals = np.cos(angle_list)
    sin_vals = np.sin(angle_list)
    plt.figure(figsize=(5, 5))
    plt.plot(cos_vals, sin_vals, "o-", label="Encoded States")
    plt.xlabel("cos(θ)")
    plt.ylabel("sin(θ)")
    plt.title("Angle Encoding on Bloch Sphere Projection")
    plt.grid(True)
    plt.legend()
    plt.show()

