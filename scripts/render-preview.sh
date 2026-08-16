#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

PAGES="${1:-1-3}"
OUTPUT_DIR="${ROOT_DIR}/.preview"
TYPST_BIN="$(./scripts/ensure-typst.sh)"

mkdir -p "${OUTPUT_DIR}"
rm -f "${OUTPUT_DIR}"/page-*.png

"${TYPST_BIN}" compile \
  --root "${ROOT_DIR}" \
  --format png \
  --pages "${PAGES}" \
  --ppi 144 \
  docs/specification.typ \
  "${OUTPUT_DIR}/page-{0p}.png"
