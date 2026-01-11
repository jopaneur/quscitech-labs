<?php
/**
 * Public Labs Landing (E1 only)
 * E2/E3 are restricted to verified book buyers and instructors.
 */
declare(strict_types=1);
function h(string $s): string { return htmlspecialchars($s, ENT_QUOTES, 'UTF-8'); }
?><!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>QuSciTech Labs — Public</title>
  <style>
    :root { color-scheme: dark; }
    body { margin:0; font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial, sans-serif; background:#0b0f14; color:#e6edf3;}
    .wrap { max-width: 980px; margin: 0 auto; padding: 34px 18px 60px; }
    h1 { font-size: 34px; margin: 0 0 6px; }
    .sub { color:#9aa4af; font-size: 14px; margin: 0 0 18px; }
    .card { background:#0f1620; border:1px solid rgba(255,255,255,.08); border-radius:16px; padding:18px; box-shadow:0 10px 30px rgba(0,0,0,.25); margin-bottom:14px;}
    .k { color:#c7d1db; font-size:12px; letter-spacing:.06em; text-transform:uppercase; margin:0 0 6px;}
    .t { font-size:18px; font-weight:700; margin:0 0 8px;}
    .p { color:#a6b3c2; margin:0 0 12px; }
    a.btn{ display:inline-block; padding:10px 14px; border-radius:10px; border:1px solid rgba(255,255,255,.14); text-decoration:none; color:#e6edf3; font-weight:700; font-size:13px; }
    a.btn.primary{ border-color: rgba(255,183,77,.45); box-shadow: 0 0 0 2px rgba(255,183,77,.08) inset; }
    .locked{ opacity:.85; }
  </style>
</head>
<body>
  <div class="wrap">
    <h1>QuSciTech Labs — Public</h1>
    <p class="sub">Public access includes E1 (Beginner / No‑Code). E2/E3 are restricted.</p>

    <div class="card">
      <div class="k">E1 — Beginner (Public)</div>
      <div class="t">E.1 — Beginner Labs (No‑Code)</div>
      <p class="p">Foundational quantum concepts delivered as no‑code notebook experiences. View rendered notebooks in-browser, or download the .ipynb.</p>
      <a class="btn primary" href="/labs/e1/">Open E1</a>
    </div>

    <div class="card locked">
      <div class="k">E2 — Intermediate (Restricted)</div>
      <div class="t">E.2 — Intermediate Labs</div>
      <p class="p">Restricted to verified book buyers and instructors.</p>
      <a class="btn" href="/labs/e1/">See Public Labs</a>
    </div>

    <div class="card locked">
      <div class="k">E3 — Advanced (Restricted)</div>
      <div class="t">E.3 — Advanced Labs</div>
      <p class="p">Restricted to verified book buyers and instructors.</p>
      <a class="btn" href="/labs/e1/">See Public Labs</a>
    </div>
  </div>
</body>
</html>
