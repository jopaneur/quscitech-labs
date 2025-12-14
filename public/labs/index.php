<?php
declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'] . '/dev/includes/access.php';

$prefix = qst_path_prefix();
$role   = qst_current_role();

$tracks = [
  [
    'id' => 'E.1',
    'title' => 'E.1 Beginner Labs (No-Code)',
    'desc' => 'Guided execution labs for readers without programming.',
    'required' => 'book_buyer',
    'href' => $prefix . '/labs/e1/',
  ],
  [
    'id' => 'E.2',
    'title' => 'E.2 Intermediate Labs (No-Code)',
    'desc' => 'Deeper experimentation with controlled variations and metrics.',
    'required' => 'book_buyer',
    'href' => $prefix . '/labs/e2/',
  ],
  [
    'id' => 'E.3',
    'title' => 'E.3 Advanced Labs (No-Code)',
    'desc' => 'Stress-tests, evaluation, and system-level exploration.',
    'required' => 'book_buyer',
    'href' => $prefix . '/labs/e3/',
  ],
];

function qst_track_cta(array $t): array {
    $required = $t['required'];
    $href     = $t['href'];
    $role     = qst_current_role();

    if (qst_has_role($required)) {
        return [
            'label' => 'Open Track',
            'href'  => $href,
            'note'  => ($role === 'instructor') ? 'Instructor role detected (full access).' : 'Unlocked.',
        ];
    }

    return [
        'label' => 'Unlock with Book Code',
        'href'  => qst_url('/labs/unlock/?return=' . rawurlencode($href)),
        'note'  => 'Premium: requires book-buyer access.',
    ];
}
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>QuSciTech Labs (DEV) — Reader Portal</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;margin:0;background:#0b1220;color:#e8eefc}
    .wrap{max-width:980px;margin:0 auto;padding:22px}
    .top{display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap}
    .badge{display:inline-block;padding:4px 10px;border-radius:999px;background:#1a2b55;border:1px solid #2a3b68}
    .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:14px;margin-top:16px}
    .card{background:#121a2d;border:1px solid #223055;border-radius:14px;padding:16px}
    .muted{color:#a7b6df}
    a.btn{display:inline-block;padding:10px 12px;border-radius:10px;border:1px solid #3d57a0;background:#1a2b55;color:#e8eefc;text-decoration:none}
    .note{margin-top:10px;color:#a7b6df;font-size:0.92rem}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="top">
      <div>
        <div class="badge">DEV</div>
        <h1 style="margin:10px 0 6px">QuSciTech Labs — Reader Portal</h1>
        <div class="muted">Current role: <strong><?php echo htmlspecialchars(qst_current_role(), ENT_QUOTES); ?></strong></div>
      </div>
      <div class="muted">
        <a class="btn" href="<?php echo htmlspecialchars(qst_url('/labs/unlock/'), ENT_QUOTES); ?>">Unlock</a>
      </div>
    </div>

    <div class="grid">
      <?php foreach ($tracks as $t): $cta = qst_track_cta($t); ?>
        <div class="card">
          <div class="badge"><?php echo htmlspecialchars($t['id'], ENT_QUOTES); ?></div>
          <h2 style="margin:10px 0 6px"><?php echo htmlspecialchars($t['title'], ENT_QUOTES); ?></h2>
          <div class="muted"><?php echo htmlspecialchars($t['desc'], ENT_QUOTES); ?></div>
          <div style="margin-top:12px">
            <a class="btn" href="<?php echo htmlspecialchars($cta['href'], ENT_QUOTES); ?>">
              <?php echo htmlspecialchars($cta['label'], ENT_QUOTES); ?>
            </a>
          </div>
          <div class="note"><?php echo htmlspecialchars($cta['note'], ENT_QUOTES); ?></div>
        </div>
      <?php endforeach; ?>
    </div>
  </div>
</body>
</html>
