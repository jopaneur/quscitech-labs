<?php
// /home/quscitech/public_html/labs/e3/index.php
// E.3 Advanced Labs — Book Access (Reader tier)

declare(strict_types=1);
session_start();

if (empty($_SESSION['qst_book_unlocked'])) {
  header('Location: /access/?return=/labs/e3/', true, 302);
  exit;
}

$BASE_FS = '/home/quscitech/public_html/labs/content/nocode/e3';
$BASE_URL = '/labs/content/nocode/e3';

$labs = [];
$slugDirs = glob($BASE_FS . '/*', GLOB_ONLYDIR) ?: [];

foreach ($slugDirs as $dir) {
  $slug = basename($dir);
  if ($slug === '_archive' || $slug === '.git') continue;

  $htmlDir = $dir . '/resources/html';
  $htmlUrl = null;

  if (is_dir($htmlDir)) {
    $candidates = glob($htmlDir . '/E3_Lab_*.html') ?: [];
    if (!$candidates) {
      $all = glob($htmlDir . '/*.html') ?: [];
      foreach ($all as $f) {
        $bn = basename($f);
        if (str_starts_with($bn, 'smoke_')) continue;
        if ($bn === 'hello-ci.html') continue;
        $candidates[] = $f;
      }
    }
    sort($candidates, SORT_STRING);
    if (!empty($candidates)) {
      $pick = $candidates[0];
      $htmlUrl = $BASE_URL . '/' . rawurlencode($slug) . '/resources/html/' . rawurlencode(basename($pick));
    }
  }

  $title = $slug;
  if ($htmlUrl) {
    $bn = basename(urldecode(parse_url($htmlUrl, PHP_URL_PATH) ?? ''));
    $name = preg_replace('/\.html$/', '', $bn);
    $name = preg_replace('/^E3_Lab_[0-9]+_/', '', $name);
    $title = str_replace('_', ' ', $name);
  } else {
    $title = str_replace('-', ' ', preg_replace('/^qais-/', '', $slug));
  }

  $labNum = null;
  if ($htmlUrl) {
    $bn = basename(urldecode(parse_url($htmlUrl, PHP_URL_PATH) ?? ''));
    if (preg_match('/^E3_Lab_([0-9]+)_/i', $bn, $m)) {
      $labNum = (int)$m[1];
    }
  }

  $labs[] = [
    'slug' => $slug,
    'title' => $title,
    'lab_num' => $labNum,
    'html_url' => $htmlUrl,
  ];
}

usort($labs, function ($a, $b) {
  $an = $a['lab_num']; $bn = $b['lab_num'];
  if (is_int($an) && is_int($bn)) return $an <=> $bn;
  if (is_int($an) && !is_int($bn)) return -1;
  if (!is_int($an) && is_int($bn)) return 1;
  return strcmp($a['title'], $b['title']);
});
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>E.3 Advanced Labs — Book Access</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link rel="stylesheet" href="/assets/site.css">
</head>
<body>
  <?php include __DIR__ . '/../../includes/header.html'; ?>

  <main style="max-width:1100px;margin:140px auto 60px;padding:0 18px;">
    <div style="display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;">
      <div>
        <h1 style="margin:0 0 6px 0;">E.3 Advanced Labs — Book Access</h1>
        <p style="margin:0;color:#cfe2ff;">Book access verified for this browser session.</p>
      </div>
      <a href="/labs/" style="color:#cfe2ff;text-decoration:none;">Back to Labs</a>
    </div>

    <?php if (empty($labs)): ?>
      <div style="margin-top:18px;padding:14px 16px;border:1px solid rgba(255,255,255,.14);border-radius:14px;">
        <p style="margin:0;">No E.3 labs found in the reader mirror path.</p>
        <p style="margin:10px 0 0 0;color:#cfe2ff;">
          Expected: <?= htmlspecialchars($BASE_FS, ENT_QUOTES, 'UTF-8') ?>
        </p>
      </div>
    <?php else: ?>
      <div style="display:grid;grid-template-columns:repeat(auto-fit,minmax(320px,1fr));gap:16px;margin-top:18px;">
        <?php foreach ($labs as $lab): ?>
          <div style="padding:16px 16px;border:1px solid rgba(255,255,255,.14);border-radius:16px;background:rgba(255,255,255,.03);">
            <div style="display:flex;align-items:center;justify-content:space-between;gap:10px;">
              <div style="font-size:.78rem;color:#cfe2ff;">
                <?= $lab['lab_num'] ? 'E3.' . (int)$lab['lab_num'] : 'E3' ?>
              </div>
              <div style="font-size:.78rem;color:#cfe2ff;opacity:.8;">
                <?= htmlspecialchars($lab['slug'], ENT_QUOTES, 'UTF-8') ?>
              </div>
            </div>

            <h2 style="margin:10px 0 12px 0;font-size:1.05rem;">
              <?= htmlspecialchars($lab['title'], ENT_QUOTES, 'UTF-8') ?>
            </h2>

            <div style="display:flex;gap:10px;flex-wrap:wrap;">
              <?php if (!empty($lab['html_url'])): ?>
                <a href="<?= htmlspecialchars($lab['html_url'], ENT_QUOTES, 'UTF-8') ?>"
                   style="display:inline-block;padding:9px 12px;border-radius:10px;background:#ffa149;color:#002244;font-weight:bold;text-decoration:none;">
                  Open Notebook
                </a>
              <?php else: ?>
                <span style="color:#cfe2ff;opacity:.85;">Notebook HTML not found</span>
              <?php endif; ?>
            </div>
          </div>
        <?php endforeach; ?>
      </div>
    <?php endif; ?>
  </main>
</body>
</html>

