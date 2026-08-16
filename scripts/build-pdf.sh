#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HTML_PATH="${ROOT_DIR}/docs/specification.html"
PDF_PATH="${ROOT_DIR}/docs/specification.pdf"

google-chrome \
  --headless=new \
  --disable-gpu \
  --no-sandbox \
  --run-all-compositor-stages-before-draw \
  --virtual-time-budget=2000 \
  --print-to-pdf-no-header \
  --print-to-pdf="${PDF_PATH}" \
  "file://${HTML_PATH}"

echo "Built ${PDF_PATH}"
