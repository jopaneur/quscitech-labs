<?php
declare(strict_types=1);

require_once $_SERVER['DOCUMENT_ROOT'] . '/dev/includes/access.php';

$prefix = qst_path_prefix();
$return = $_SERVER['REQUEST_URI'] ?? ($prefix . '/labs/e3/');

if (!qst_has_role('book_buyer')) {
    header('Location: ' . qst_url('/labs/unlock/?return=' . rawurlencode($return)), true, 302);
    exit;
}
?>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>E.3 — Advanced Labs (No-Code)</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body style="font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;margin:20px;">
  <h1>E.3 — Advanced Labs (No-Code)</h1>
  <p><strong>Access:</strong> Unlocked (book-buyer)</p>

  <p>
    This is the E.3 track landing page. Replace this body with your actual E.3 track UI (cards, badges, notebook links, etc.).
  </p>

  <p>
    <a href="<?php echo htmlspecialchars($prefix . '/labs/', ENT_QUOTES); ?>">← Back to Reader Portal</a>
  </p>
</body>
</html>
