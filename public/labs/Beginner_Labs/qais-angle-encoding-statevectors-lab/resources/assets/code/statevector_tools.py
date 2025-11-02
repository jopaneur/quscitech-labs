"""
statevector_tools.py — Helper functions for Angle Encoding Labs
Part of: QAIS Intermediate Lab Series

Purpose:
Provides quantum statevector helpers for no-code visualizations.
Fully compatible with qiskit, pennylane, or matplotlib if extended later.
Can be imported inside notebooks using:
from resources.assets.code.statevector_tools import angle_to_statevec
"""

import numpy as np

def angle_to_statevector(angle_rad: float) -> np.ndarray:
    """
    Converts a classical angle (in radians) to a single-qubit statevector.
    |ψ⟩ = cos(θ/2)|0⟩ + sin(θ/2)|1⟩
    """
    theta = angle_rad
    return np.array([np.cos(theta / 2), np.sin(theta / 2)], dtype=complex)

def generate_statevectors(angle_list):
    """
    Generate statevectors for a list of angles.
    Returns a NumPy array of shape (n, 2).
    """
    return np.array([angle_to_statevector(a) for a in angle_list])

def print_statevector(angle_rad):
    """Pretty-print the statevector for a given angle."""
    vec = angle_to_statevector(angle_rad)
    print(f"θ = {angle_rad:.4f} rad → |ψ⟩ = {vec[0]:.4f}|0⟩ + {vec[1]:.4f}|1⟩")

def normalize(vec):
    """Ensure a complex vector is normalized."""
    norm = np.linalg.norm(vec)
    if norm == 0:
        return vec
    return vec / norm

if __name__ == "__main__":
    print("Angle Encoding — Quick Demo")
    angles = np.linspace(0, np.pi, 5)
    for a in angles:
        print_statevector(a)

