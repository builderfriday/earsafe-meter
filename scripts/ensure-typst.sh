#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TYPST_VERSION="0.13.1"
TYPST_ARCHIVE="typst-x86_64-unknown-linux-musl.tar.xz"
TYPST_URL="https://github.com/typst/typst/releases/download/v${TYPST_VERSION}/${TYPST_ARCHIVE}"
TYPST_SHA256="7d214bfeffc2e585dc422d1a09d2b144969421281e8c7f5d784b65fc69b5673f"
TOOLS_DIR="${ROOT_DIR}/.tools"
TYPST_DIR="${TOOLS_DIR}/typst-x86_64-unknown-linux-musl"
TYPST_BIN="${TYPST_DIR}/typst"
ARCHIVE_PATH="${TOOLS_DIR}/${TYPST_ARCHIVE}"

mkdir -p "${TOOLS_DIR}"

if [[ ! -x "${TYPST_BIN}" ]]; then
  rm -rf "${TYPST_DIR}" "${ARCHIVE_PATH}"
  curl -fsSL -o "${ARCHIVE_PATH}" "${TYPST_URL}"
  echo "${TYPST_SHA256}  ${ARCHIVE_PATH}" | sha256sum -c -
  tar -xf "${ARCHIVE_PATH}" -C "${TOOLS_DIR}"
fi

printf '%s\n' "${TYPST_BIN}"
