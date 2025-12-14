<?php
declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'] . '/dev/includes/access.php';

$prefix = qst_path_prefix();

function qst_safe_return(string $candidate, string $default): string {
    $candidate = trim($candidate);

    if ($candidate === '') {
        return $default;
    }

    // Only allow same-site relative returns under /dev/
    // Accept:
    //   /dev/labs/...
    //   /dev/instructors/... (if you ever reuse)
    // Reject full URLs and protocol-relative URLs.
    if (preg_match('~^https?://~i', $candidate) || str_starts_with($candidate, '//')) {
        return $default;
    }

    if (!str_starts_with($candidate, '/dev/')) {
        return $default;
    }

    return $candidate;
}

$return = isset($_GET['return']) && is_string($_GET['return']) ? $_GET['return'] : ($prefix . '/labs/');
$return = qst_safe_return($return, $prefix . '/labs/');

if (isset($_GET['logout'])) {
    qst_logout();
    header('Location: ' . qst_url('/labs/'), true, 302);
    exit;
}

$secretsPath = $_SERVER['DOCUMENT_ROOT'] . '/dev/includes/secrets.php';
$secrets = null;
if (is_readable($secretsPath)) {
    $secrets = require $secretsPath;
}

$bookCodes = (is_array($secrets) && isset($secrets['book_buyer_codes']) && is_array($secrets['book_buyer_codes']))
    ? $secrets['book_buyer_codes']
    : [];

$err = '';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $code = $_POST['code'] ?? '';
    $code = is_string($code) ? trim($code) : '';

    if (count($bookCodes) === 0) {
        $err = 'Book-buyer codes are not configured on this server yet. (DEV) Add /dev/includes/secrets.php';
    } elseif ($code === '') {
        $err = 'Please enter your book unlock code.';
    } else {
        if (in_array($code, $bookCodes, true)) {
            qst_set_role('book_buyer');
            header('Location: ' . $return, true, 302);
            exit;
        }
        $err = 'That book code was not recognized.';
    }
}
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Book Buyer Unlock</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <style>
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;margin:0;background:#0b1220;color:#e8eefc}
    .wrap{max-width:760px;margin:0 auto;padding:28px}
    .card{background:#121a2d;border:1px solid #223055;border-radius:14px;padding:18px}
    .muted{color:#a7b6df}
    .row{display:flex;gap:10px;flex-wrap:wrap;margin-top:12px}
    input{flex:1;min-width:220px;padding:12px;border-radius:10px;border:1px solid #2a3b68;background:#0e1628;color:#e8eefc}
    button{padding:12px 14px;border-radius:10px;border:1px solid #3d57a0;background:#1a2b55;color:#e8eefc;cursor:pointer}
    a{color:#9fc2ff}
    .err{margin-top:10px;color:#ffb3b3}
    .pill{display:inline-block;padding:4px 10px;border-radius:999px;background:#1a2b55;border:1px solid #2a3b68}
  </style>
</head>
<body>
  <div class="wrap">
    <div class="card">
      <div class="pill">Reader Portal</div>
      <h1 style="margin:12px 0 6px">Unlock No-Code Labs (Book Buyer)</h1>
      <p class="muted" style="margin:0 0 10px">
        Enter your book unlock code to access E.1/E.2/E.3 no-code labs.
      </p>

      <form method="post" action="">
        <div class="row">
          <input name="code" type="text" placeholder="Enter book unlock code" autocomplete="off" />
          <button type="submit">Unlock</button>
        </div>
        <?php if ($err !== ''): ?>
          <div class="err"><?php echo htmlspecialchars($err, ENT_QUOTES); ?></div>
        <?php endif; ?>
      </form>

      <hr style="border:none;border-top:1px solid #223055;margin:16px 0">

      <p class="muted" style="margin:0">
        Current role: <strong><?php echo htmlspecialchars(qst_current_role(), ENT_QUOTES); ?></strong>
        · <a href="<?php echo htmlspecialchars($prefix . '/labs/', ENT_QUOTES); ?>">Back to Reader Portal</a>
        · <a href="<?php echo htmlspecialchars(qst_url('/labs/unlock/?logout=1'), ENT_QUOTES); ?>">Log out</a>
      </p>
    </div>
  </div>
</body>
</html>
