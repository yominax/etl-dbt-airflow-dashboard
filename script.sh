#!/usr/bin/env bash
set -euo pipefail

REPO="${1:-}"   # ex: git@github.com:org/repo.git or https://github.com/org/repo.git
DEST="${2:-./repo}"

if [[ -z "$REPO" ]]; then
  echo "Usage: $0 <repo-url> [dest-dir]"
  exit 1
fi

git clone --depth 1 "$REPO" "$DEST"
echo "Cloned $REPO -> $DEST"
