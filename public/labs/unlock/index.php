<?php
// public/labs/unlock/index.php
// Legacy path maintained for backward compatibility.
// Canonical book unlock flow lives at /access/.

declare(strict_types=1);

$return = $_GET['return'] ?? '/labs/';
if (!is_string($return) || $return === '') $return = '/labs/';

// Safe-return: only allow local paths.
if ($return[0] !== '/' || str_contains($return, "\n") || str_contains($return, "\r")) {
  $return = '/labs/';
}

// Redirect to the canonical book access page.
header('Location: /access/?return=' . rawurlencode($return), true, 302);
exit;
