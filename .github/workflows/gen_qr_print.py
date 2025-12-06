name: Generate QR Codes (Print)

on:
  push:
    branches: [ main ]
    paths:
      - 'tools/gen_qr_print.py'
      - '.github/workflows/qr-print.yml'
  workflow_dispatch: {}

jobs:
  qr-print:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'

      - name: Install segno
        run: pip install segno

      - name: Generate QR SVGs
        run: python tools/gen_qr_print.py

      - name: Commit updated QR codes
        uses: stefanzweifel/git-auto-commit-action@v5
        with:
          commit_message: "chore: update print QR codes"
          file_pattern: "public/api/assets/images/qr-print/*.svg"
