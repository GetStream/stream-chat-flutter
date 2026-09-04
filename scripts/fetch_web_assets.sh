#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Usage:
#   melos run web:assets
#
# Downloads the two files stream_chat_persistence needs to run sqlite3 in a
# browser into every web app in this repo:
#
#   sqlite3.wasm    - the sqlite3 C library compiled to WebAssembly
#   drift_worker.js - the worker drift hosts the database in
#
# Both are published together in a single drift GitHub release, which is the
# only combination guaranteed to be compatible: sqlite3.wasm has to match the
# `sqlite3` version drift resolves, and `sqlite3` is only a transitive
# dependency here. Taking both from one release makes that impossible to get
# wrong.
#
# DRIFT_VERSION must stay in sync with the `drift` constraint in melos.yaml.
# Bump it there, bump it here, re-run this script, commit the result.
#
# Requires: curl
# ============================================================

DRIFT_VERSION="2.34.4"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE_URL="https://github.com/simolus3/drift/releases/download/drift-${DRIFT_VERSION}"

ASSETS=(
  "sqlite3.wasm"
  "drift_worker.js"
)

TARGETS=(
  "sample_app/web"
  "packages/stream_chat_flutter/example/web"
  "packages/stream_chat_persistence/example/web"
)

echo "Fetching drift ${DRIFT_VERSION} web assets"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

for asset in "${ASSETS[@]}"; do
  echo "  downloading ${asset}"
  curl --fail --location --silent --show-error \
    --output "${TMP_DIR}/${asset}" \
    "${BASE_URL}/${asset}"
done

for target in "${TARGETS[@]}"; do
  target_dir="${ROOT_DIR}/${target}"
  if [[ ! -d "$target_dir" ]]; then
    echo "  skipping ${target} (not found)"
    continue
  fi
  for asset in "${ASSETS[@]}"; do
    cp "${TMP_DIR}/${asset}" "${target_dir}/${asset}"
  done
  echo "  updated ${target}"
done

echo "Done."
