/* Bell-State (Correlated Outcomes) — Beginner Lab
 * State: |Φ+> = (|00> + |11>) / sqrt(2)
 * Simple model: measurements in the same Z-basis yield perfectly correlated bits
 * (00 or 11). A small 'noise' parameter ε flips either bit with probability ε.
 * No external libs; renders a table and a simple bar chart.
 */

(function () {
  // Config with safe defaults
  const N = 1000;          // pairs
  const EPS = 0.02;        // noise: 2% bit-flip chance per qubit
  const seed = 42;         // deterministic RNG for reproducibility

  // PRNG (xorshift32) to keep results stable without crypto RNG.
  let x = seed >>> 0;
  function rnd() {
    x ^= x << 13; x >>>= 0;
    x ^= x >>> 17; x >>>= 0;
    x ^= x << 5;  x >>>= 0;
    return (x >>> 0) / 0xFFFFFFFF;
  }

  // Simulate N correlated outcomes (00 or 11) with occasional flips.
  const counts = { "00": 0, "01": 0, "10": 0, "11": 0 };

  for (let i = 0; i < N; i++) {
    // Bell Φ+ produces 00 or 11 equally likely
    const base = rnd() < 0.5 ? "00" : "11";
    let a = base[0] === "0" ? 0 : 1;
    let b = base[1] === "0" ? 0 : 1;

    // independent noise flips
    if (rnd() < EPS) a ^= 1;
    if (rnd() < EPS) b ^= 1;

    const key = `${a}${b}`;
    counts[key]++;
  }

  // Derived stats
  const same = counts["00"] + counts["11"];
  const diff = counts["01"] + counts["10"];
  const corr = (same - diff) / (same + diff); // correlation coefficient in {−1..1}

  // Render table
  function renderTable(el) {
    const rows = [
      ["Outcome", "Count"],
      ["00", counts["00"]],
      ["01", counts["01"]],
      ["10", counts["10"]],
      ["11", counts["11"]],
      ["—", "—"],
      ["Total", same + diff],
      ["Same (00+11)", same],
      ["Different (01+10)", diff],
      ["Correlation (Z,Z)", corr.toFixed(3)]
    ];

    const table = document.createElement("table");
    table.className = "qst-table";
    rows.forEach((r, i) => {
      const tr = document.createElement("tr");
      r.forEach((cell, j) => {
        const tag = i === 0 ? "th" : "td";
        const td = document.createElement(tag);
        td.textContent = cell;
        if (i === 0) td.setAttribute("scope", "col");
        tr.appendChild(td);
      });
      table.appendChild(tr);
    });
    el.innerHTML = "";
    el.appendChild(table);
  }

  // Render bar chart on canvas (no external libs)
  function renderChart(canvas) {
    const ctx = canvas.getContext("2d");
    const W = canvas.width, H = canvas.height;
    ctx.clearRect(0, 0, W, H);

    const keys = ["00", "01", "10", "11"];
    const vals = keys.map(k => counts[k]);
    const maxv = Math.max(...vals) || 1;

    // axes
    ctx.lineWidth = 1;
    ctx.strokeStyle = "#9fb4d9";
    ctx.beginPath();
    ctx.moveTo(50, 10);
    ctx.lineTo(50, H - 30);
    ctx.lineTo(W - 10, H - 30);
    ctx.stroke();

    // bars
    const barW = 50, gap = 30;
    let x0 = 70;
    ctx.fillStyle = "#ffa149";
    vals.forEach((v, i) => {
      const h = Math.round((H - 60) * (v / maxv));
      ctx.fillRect(x0, H - 30 - h, barW, h);
      ctx.fillStyle = "#d7e6ff";
      ctx.fillText(keys[i], x0 + 15, H - 12);
      ctx.fillText(String(v), x0 + 10, H - 35 - h);
      ctx.fillStyle = "#ffa149";
      x0 += barW + gap;
    });

    // title
    ctx.fillStyle = "#d7e6ff";
    ctx.font = "16px Arial";
    ctx.fillText("Bell Φ+ — Correlated Outcomes (Z,Z)", 55, 24);
  }

  // Bootstrap once DOM is ready
  window.addEventListener("DOMContentLoaded", () => {
    const tableEl = document.getElementById("results");
    const canvas  = document.getElementById("bellChart");
    renderTable(tableEl);
    if (canvas && canvas.getContext) {
      renderChart(canvas);
    } else {
      // If canvas unsupported, show static fallback (if present)
      const fb = document.getElementById("imgFallback");
      if (fb) fb.hidden = false;
    }
  });
})();

