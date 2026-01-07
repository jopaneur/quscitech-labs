<?php
// /home/quscitech/public_html/access/index.php
// PUBLIC book-code unlock (Reader tier)

declare(strict_types=1);

session_start();
require_once __DIR__ . '/../includes/access.php'; // loads secrets + qst_is_valid_book_code()

// --------------------
// Safe return handling
// --------------------
$return = $_GET['return'] ?? $_POST['return'] ?? '/labs/';
if (!is_string($return) || $return === '') {
  $return = '/labs/';
}

// Allow only local absolute paths; block CRLF injection
if ($return[0] !== '/' || str_contains($return, "\n") || str_contains($return, "\r")) {
  $return = '/labs/';
}

// Optional hardening: allow only /labs paths (including /labs/e2/, /labs/e3/)
if (!str_starts_with($return, '/labs')) {
  $return = '/labs/';
}

$err = '';
$code_prefill = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
  $code_prefill = (string)($_POST['code'] ?? '');
  $code = strtoupper(trim($code_prefill));

  if (!preg_match('/^BOOK-[A-Z0-9]{4}-[A-Z0-9]{4}$/', $code)) {
    $err = 'Invalid code format. Please check the code and try again.';
  } elseif (!qst_is_valid_book_code($code)) {
    $err = 'Code not recognized. If you just purchased, please confirm you entered it exactly.';
  } else {
    // Book unlock session (separate from instructor unlock)
    $_SESSION['qst_book_unlocked'] = true;
    $_SESSION['qst_book_unlocked_at'] = time();

    header('Location: ' . $return, true, 302);
    exit;
  }
}
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>QuSciTech — Book Access</title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <link rel="stylesheet" href="/assets/site.css">
</head>
<body>
  <?php include __DIR__ . '/../includes/header.html'; ?>

  <main style="max-width:920px;margin:140px auto 60px;padding:0 18px;">
    <h1>Unlock with Book Access</h1>
    <p>Enter your book access code to unlock E.2 and E.3 features (as permitted for your access tier).</p>

    <?php if ($err): ?>
      <div style="padding:12px 14px;border:1px solid rgba(255,0,0,.35);border-radius:10px;margin:16px 0;">
        <?= htmlspecialchars($err, ENT_QUOTES, 'UTF-8') ?>
      </div>
    <?php endif; ?>

    <form method="post" action="/access/">
      <input type="hidden" name="return" value="<?= htmlspecialchars($return, ENT_QUOTES, 'UTF-8') ?>">

      <label for="code" style="display:block;margin:16px 0 6px;">Book code</label>
      <input
        id="code"
        name="code"
        type="text"
        placeholder="BOOK-XXXX-YYYY"
        required
        value="<?= htmlspecialchars($code_prefill, ENT_QUOTES, 'UTF-8') ?>"
        style="width:min(520px,100%);padding:10px 12px;border-radius:10px;border:1px solid rgba(255,255,255,.18);background:#0b0f14;color:#eef2f6;"
      >

      <div style="margin-top:14px;">
        <button
          type="submit"
          style="padding:10px 14px;border-radius:10px;border:0;background:#ffa149;color:#002244;font-weight:bold;cursor:pointer;"
        >
          Unlock
        </button>

        <a href="/buy.html" style="margin-left:14px;color:#cfe2ff;">Need a code? Purchase the book</a>
      </div>
    </form>

    <p style="margin-top:22px;color:#cfe2ff;font-size:.95rem;">
      Tip: Codes are case-insensitive. Hyphens are required.
    </p>
  </main>
</body>
</html>
