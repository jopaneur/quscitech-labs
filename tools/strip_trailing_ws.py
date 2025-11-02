#!/usr/bin/env python3
"""
Strip trailing whitespace, normalize line endings to LF, and ensure a single
newline at EOF. Skips markdown hard-breaks, notebooks, and obvious binaries.
Usage:
  git ls-files -z | xargs -0 python tools/strip_trailing_ws.py
"""
import sys, pathlib, mimetypes

SKIP_EXT = {
    ".md", ".ipynb", ".png", ".jpg", ".jpeg", ".gif", ".ico",
    ".svg", ".pdf", ".zip", ".tar", ".gz", ".tgz", ".7z"
}

def is_probably_binary(b: bytes) -> bool:
    # Heuristic: null bytes or a very high ratio of non-text chars
    if b'\x00' in b:
        return True
    # Allow; we handle via decode errors anyway
    return False

def clean_text(s: str, suffix: str) -> str:
    # Preserve MD hard breaks (two spaces at end of line) by skipping .md
    if suffix == ".md":
        # Only normalize line endings + ensure newline at EOF
        s = s.replace("\r\n", "\n").replace("\r", "\n")
        if not s.endswith("\n"):
            s += "\n"
        return s

    # Generic text cleanup
    s = s.replace("\r\n", "\n").replace("\r", "\n")
    lines = [ln.rstrip() for ln in s.split("\n")]
    s = "\n".join(lines) + "\n"
    return s

def main():
    for path_str in sys.argv[1:]:
        p = pathlib.Path(path_str)
        if not p.exists() or not p.is_file():
            continue
        suffix = p.suffix.lower()
        if suffix in SKIP_EXT:
            continue

        # Skip non-text-ish files by MIME
        mtype, _ = mimetypes.guess_type(p.name)
        if mtype and not mtype.startswith("text"):
            # still allow try-decode
            pass

        try:
            raw = p.read_bytes()
        except Exception:
            continue
        if is_probably_binary(raw):
            continue

        try:
            s = raw.decode("utf-8")
        except Exception:
            # Not UTF-8 text → skip
            continue

        cleaned = clean_text(s, suffix)
        if cleaned != s:
            p.write_text(cleaned, encoding="utf-8")
            print(f"fixed: {p}", file=sys.stderr)

if __name__ == "__main__":
    if len(sys.argv) == 1:
        print("No files provided on stdin/args.", file=sys.stderr)
        sys.exit(0)
    main()
