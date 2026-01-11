<?php
/**
 * QuSciTech Public Labs — E.1 (Beginner / No-Code)
 *
 * Canonical server layout (web paths):
 *   /labs/content/nocode/e1/<lab-slug>/resources/{notebooks,html}/
 *
 * Buttons:
 *   - Open Notebook: opens HTML view if present, else falls back to .ipynb on server
 *   - View on GitHub: opens the notebooks directory in the public repo
 *   - Open in Colab: opens the SAME notebook file from GitHub (must exist in repo)
 *
 * Notes:
 *   - Public E1 does NOT offer a direct server download button (download via GitHub instead).
 *   - Colab links must match the exact GitHub filename. Canonical is:
 *       E1_*.ipynb   (NO "E.1_*" and NO "*_NoCode.ipynb")
 */

declare(strict_types=1);

// ----------------------------
// CONFIG
// ----------------------------
$TRACK_LABEL = 'E.1 Beginner Labs — Public View';

// Web path (NOT filesystem path) for server canonical content
$BASE_DIR = '/labs/content/nocode/e1';

// Public GitHub mirror
$GITHUB_REPO   = 'jopaneur/quscitech-labs';
$GITHUB_BRANCH = 'main';

// Repo prefix for E1 labs (matches your GitHub tree)
$GITHUB_PREFIX = 'public/labs/Beginner_Labs';

// ----------------------------
// DATA (E1) — keep in sync with server manifest
// ----------------------------
$labs = [
  ['code'=>'E1.1','title'=>'Superposition & Probability Distribution','slug'=>'qais-superposition-lab','file'=>'E1_1_Superposition_Probability_Distribution.ipynb'],
  ['code'=>'E1.2','title'=>'Bell State & Correlated Outcomes','slug'=>'qais-bell-state-correlated-outcomes-lab','file'=>'E1_2_Bell_State_Correlated_Outcomes.ipynb'],
  ['code'=>'E1.3','title'=>'Angle Encoding & Statevectors','slug'=>'qais-angle-encoding-statevectors-lab','file'=>'E1_3_Angle_Encoding_Statevectors.ipynb'],
  ['code'=>'E1.4','title'=>'Circuit Depth & Noise Sensitivity','slug'=>'qais-depth-noise-sensitivity-lab','file'=>'E1_4_Depth_Noise_Sensitivity.ipynb'],
  ['code'=>'E1.5','title'=>'Quantum Teleportation Protocol Demo','slug'=>'qais-quantum-teleportation-lab','file'=>'E1_5_Quantum_Teleportation_Protocol_Demo.ipynb'],
];

// ----------------------------
// HELPERS
// ----------------------------
function h(string $s): string { return htmlspecialchars($s, ENT_QUOTES, 'UTF-8'); }

function file_fs(string $webPath): string {
  $webPath = '/' . ltrim($webPath, '/');
  return rtrim($_SERVER['DOCUMENT_ROOT'], '/') . $webPath;
}

function exists_web(string $webPath): bool {
  return is_file(file_fs($webPath));
}

function github_tree_url(string $repo, string $branch, string $path): string {
  $path = ltrim($path, '/');
  return "https://github.com/{$repo}/tree/{$branch}/{$path}";
}

function colab_url(string $repo, string $branch, string $path): string {
  // IMPORTANT: path must match GitHub EXACTLY. (Colab uses GitHub API to resolve the file.)
  $path = ltrim($path, '/');
  return "https://colab.research.google.com/github/{$repo}/blob/{$branch}/{$path}";
}

// ----------------------------
// PAGE
// ----------------------------
?><!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title><?= h($TRACK_LABEL) ?></title>
  <style>
    body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;background:#0b1220;color:#e7eefc}
    .wrap{max-width:1100px;margin:0 auto;padding:28px 18px 60px}
    h1{font-size:34px;letter-spacing:.2px;margin:0 0 6px}
    .sub{opacity:.85;margin:0 0 20px}
    .topbar{display:flex;justify-content:space-between;align-items:center;gap:12px;margin-bottom:18px}
    .btn{display:inline-block;padding:10px 14px;border-radius:10px;border:1px solid rgba(255,255,255,.18);text-decoration:none;color:#e7eefc;font-weight:600;font-size:13px;line-height:1;background:rgba(255,255,255,.04)}
    .btn:hover{border-color:rgba(255,255,255,.32)}
    .grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:16px}
    @media (max-width:900px){.grid{grid-template-columns:1fr}}
    .card{background:rgba(255,255,255,.04);border:1px solid rgba(255,255,255,.10);border-radius:18px;padding:16px;box-shadow:0 10px 30px rgba(0,0,0,.35)}
    .tag{display:inline-block;font-size:11px;padding:4px 8px;border-radius:999px;background:rgba(255,255,255,.06);border:1px solid rgba(255,255,255,.10);margin-bottom:8px}
    .title{font-size:18px;font-weight:800;margin:6px 0 8px}
    .path{font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,monospace;font-size:12px;opacity:.85;word-break:break-all;margin:0 0 10px}
    .actions{display:flex;flex-wrap:wrap;gap:10px;margin-top:8px}
    .btn.primary{border-color:rgba(255,170,70,.45);background:rgba(255,170,70,.10)}
    .warn{margin-top:10px;font-size:12px;color:#ffb199;opacity:.95}
    .hint{margin-top:6px;font-size:12px;opacity:.9}
    code{font-family:ui-monospace,SFMono-Regular,Menlo,Monaco,Consolas,monospace}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="topbar">
      <div>
        <h1><?= h($TRACK_LABEL) ?></h1>
        <p class="sub">Public access: E1 only. E2/E3 are restricted to verified book buyers and instructors.</p>
      </div>
      <div>
        <a class="btn" href="/labs.php">Back to Labs</a>
      </div>
    </div>

    <div class="grid">
      <?php foreach ($labs as $lab):
        $code  = $lab['code'];
        $title = $lab['title'];
        $slug  = $lab['slug'];
        $file  = $lab['file'];

        $nb_web   = "{$BASE_DIR}/{$slug}/resources/notebooks/{$file}";
        $html_web = "{$BASE_DIR}/{$slug}/resources/html/" . pathinfo($file, PATHINFO_FILENAME) . ".html";

        $open_url = exists_web($html_web) ? $html_web : $nb_web;

        $gh_dir_path  = "{$GITHUB_PREFIX}/{$slug}/resources/notebooks";
        $gh_file_path = "{$gh_dir_path}/{$file}"; // canonical filename
        $github_url   = github_tree_url($GITHUB_REPO, $GITHUB_BRANCH, $gh_dir_path);
        $colab_link   = colab_url($GITHUB_REPO, $GITHUB_BRANCH, $gh_file_path);

        $missing = [];
        if (!exists_web($nb_web))   { $missing[] = "Missing on server: {$nb_web}"; }
        if (!exists_web($html_web)) { $missing[] = "Missing HTML view on server: {$html_web}"; }
      ?>
        <div class="card">
          <div class="tag"><?= h($code) ?></div>
          <div class="title"><?= h($title) ?></div>
          <div class="path"><?= h(ltrim($nb_web, '/')) ?></div>

          <div class="actions">
            <a class="btn primary" href="<?= h($open_url) ?>" target="_blank" rel="noopener">Open Notebook</a>
            <a class="btn" href="<?= h($github_url) ?>" target="_blank" rel="noopener">View on GitHub</a>
            <a class="btn" href="<?= h($colab_link) ?>" target="_blank" rel="noopener">Open in Colab</a>
          </div>

          <?php if ($missing): ?>
            <div class="warn">
              <?php foreach ($missing as $m): ?>
                &#9888; <?= h($m) ?><br>
              <?php endforeach; ?>
              <div class="hint">
                If Colab says “Notebook not found”, the GitHub filename/path must match exactly.
                Expected: <code><?= h($gh_file_path) ?></code>
              </div>
            </div>
          <?php endif; ?>
        </div>
      <?php endforeach; ?>
    </div>
  </div>
</body>
</html>
