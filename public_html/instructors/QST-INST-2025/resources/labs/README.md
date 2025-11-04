# QuSciTech Labs — Web-Ready Learning Layout

This folder hosts the **deployed Quantum AI Systems (QAIS) laboratory modules** in a **flat layout** for web delivery.  
Each lab folder here corresponds to a self-contained experiment or guided exercise.  
While all labs live in this single directory for simplified hosting, they are **grouped conceptually** into three tiers of learning progression:

---

## 🧭 Beginner Labs — Foundational Quantum Concepts

Labs in this tier introduce quantum states, measurement, and simple quantum circuits.  
They are ideal for learners new to quantum information science.

| Folder | Title / Focus |
|:--|:--|
| `qais-superposition-lab` | Basic superposition and measurement collapse |
| `qais-bell-state-correlated-outcomes-lab` | Entanglement and correlated measurement outcomes |
| `qais-angle-encoding-statevectors-lab` | Angle-based state encoding into qubit amplitudes |
| `qais-depth-noise-sensitivity-lab` | Circuit depth vs. noise sensitivity |
| `qais-quantum-teleportation-lab` | Quantum teleportation protocol demonstration |

---

## ⚙️ Intermediate Labs — Core Protocols and Metrics

These labs cover mid-level topics such as QKD, fidelity, kernel methods, and variational algorithms.  
They develop the skills to evaluate, optimize, and compare quantum operations.

| Folder | Title / Focus |
|:--|:--|
| `qais-BB84-QKD-lab` | Quantum key distribution using the BB84 protocol |
| `qais-entanglement-tamper-check-lab` | Detecting tampering through entanglement fidelity checks |
| `qais-fidelity-trace-distance-lab` | State comparison via fidelity and trace distance |
| `qais-VQE-Toy-Minimization-lab` | Toy example of a variational quantum eigensolver (VQE) |
| `qais-quantum-kernel-svm-vs-logregression-lab` | Quantum kernel SVM vs. logistic regression |
| `qais-zz-expectation-scan-lab` | Expectation value scanning for ZZ interactions |

---

## 🚀 Advanced Labs — System-Level & Adversarial Scenarios

Advanced modules integrate multiple quantum and AI layers, examining noise models, stress tests, and resilience frameworks.  
They also showcase the **CRQC–LLM** and **QALIS** system perspectives introduced in the textbook.

| Folder | Title / Focus |
|:--|:--|
| `qais-grover-success-vs-noise` | Grover algorithm success rate under noise |
| `qais-chsh-correlation-sweep-lab` | CHSH inequality correlation sweeps |
| `qais-density-matrix-encoding-metrics-lab` | Density matrix metrics for mixed states |
| `qais-hybrid-pipeline-quantum-kernel-svm-lab` | Hybrid classical-quantum ML pipeline |
| `qais-tiny-vqc-vs-logregression-lab` | Mini variational quantum classifier vs. logistic regression |
| `qais-bloch-trajectories-lab` | Bloch sphere trajectory visualization |
| `qais-case-study-qalis-vs-crqc-llm-lab` | Extended case study: QALIS vs. CRQC–LLM framework comparison |

---

## 📂 Structure & Usage

- Each lab directory contains its own **`README.md`**, **notebooks**, and **resources/assets/data/** folder.
- The flat layout makes web access simpler (no nested Beginner/Intermediate/Advanced folders).
- Learners can browse or clone individual labs directly.

resources/labs/
├── qais-superposition-lab/
├── qais-BB84-QKD-lab/
├── qais-case-study-qalis-vs-crqc-llm-lab/
└── ... etc.


For deeper theory or references, see the corresponding chapters in *Quantum AI Systems: Theory, Architecture, and Applications*.

---

**Support:** support@quscitech.com  
**Operations:** ops@quscitech.com  
© QuSciTech / TelcoCapital IT Solutions — All rights reserved.

