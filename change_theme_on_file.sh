#!/usr/bin/env bash
set -euo pipefail


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT_DIR="$script_dir"
LUA_DIR="${SCRIPT_DIR}/lua"
TEMPLATE="${SCRIPT_DIR}/theme-template.lua"
OUT="${SCRIPT_DIR}/theme.lua"

slug="${1:-}"
if [[ -z "$slug" ]]; then
  echo "Usage: $(basename "$0") <theme-slug>"
  exit 1
fi

theme_file="${LUA_DIR}/${slug}.lua"
if [[ ! -f "$theme_file" ]]; then
  echo "Theme '${slug}' not found at ${theme_file}"
  echo "Available themes:"
  ls -1 "${LUA_DIR}" | sed 's/\.lua$//' | sort
  exit 1
fi

marker_phrase='this will be replaced with activating the current colorscheme'

# Fail early if the marker is missing, to avoid writing an unchanged file.
if ! grep -q "$marker_phrase" "$TEMPLATE"; then
  echo "Marker not found in template. Expected a line containing:"
  echo "  -- <${marker_phrase}>"
  exit 1
fi

# Replace the marker line with the theme file's contents.
# Works on both GNU sed and BSD/macOS sed.
sed "/${marker_phrase}/{
  r ${theme_file}
  d
}" "$TEMPLATE" > "$OUT"

echo "✅ Theme set to '${slug}'. Wrote ${OUT}"
