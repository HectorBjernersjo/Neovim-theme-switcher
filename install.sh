#!/usr/bin/env bash
set -euo pipefail

# --- Resolve paths and configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Bring in NVIM_THEME_FILE (and optionally OMARCHY_THEME_HOOK_FILE) from config.sh
# shellcheck source=/dev/null
source "$SCRIPT_DIR/config.sh"

if [[ -z "${NVIM_THEME_FILE:-}" ]]; then
  echo "Error: NVIM_THEME_FILE is not set. Please set it in config.sh"
  exit 1
fi

# Expand '~' if present
TARGET="${NVIM_THEME_FILE/#\~/$HOME}"

echo "== Neovim Theme Switcher – Installation =="
echo
echo "1) Installing theme selector file into your Neovim config."
echo "   Target file: $TARGET"
echo "   This file should be included by your Lazy.nvim plugin spec."
echo

# Ensure parent directory exists
PARENT_DIR="$(dirname "$TARGET")"
if [[ ! -d "$PARENT_DIR" ]]; then
  echo "   Creating directory: $PARENT_DIR"
  mkdir -p "$PARENT_DIR"
fi

# --- Symlink theme.lua into place (prompt if something exists) ---
if [[ -e "$TARGET" || -L "$TARGET" ]]; then
  echo
  echo "2) A file already exists at: $TARGET"
  read -r -p "   Overwrite with a symlink to $SCRIPT_DIR/theme.lua? [y/N] " ans
  if [[ "$ans" =~ ^[Yy]$ ]]; then
    ln -sfn "$SCRIPT_DIR/theme.lua" "$TARGET"
    echo "   Replaced with symlink → $TARGET → $SCRIPT_DIR/theme.lua"
  else
    echo "   Skipped replacing existing file."
    exit 0
  fi
else
  ln -s "$SCRIPT_DIR/theme.lua" "$TARGET"
  echo "2) Created symlink → $TARGET → $SCRIPT_DIR/theme.lua"
fi

echo

# --- Optional: Omarchy hook ---
read -r -p "3) Do you use Omarchy to manage themes? [y/N] " use_omarchy
if [[ "$use_omarchy" =~ ^[Yy]$ ]]; then
  # Default from config or sensible fallback
  DEFAULT_HOOK="${OMARCHY_THEME_HOOK_FILE/#\~/$HOME}"

  read -r -p "   Hook file to append to? [${DEFAULT_HOOK}] " hook_input
  HOOK_FILE="${hook_input:-$DEFAULT_HOOK}"
  HOOK_FILE="${HOOK_FILE/#\~/$HOME}"

  # Create parent directory and file
  mkdir -p "$(dirname "$HOOK_FILE")"
  touch "$HOOK_FILE"

  # This is the line Omarchy should call with the theme slug as $1
  HOOK_LINE="$SCRIPT_DIR/change_theme.sh \"\$1\""

  if grep -Fqx -- "$HOOK_LINE" "$HOOK_FILE"; then
    echo "   Hook already present in: $HOOK_FILE"
  else
    printf '%s\n' "$HOOK_LINE" >> "$HOOK_FILE"
    chmod +x "$HOOK_FILE" || true
    echo "   Added hook to: $HOOK_FILE"
    echo "   → $HOOK_LINE"
  fi
else
  echo "3) Skipping Omarchy hook."
fi

echo
echo "== Installation Summary =="
echo "- Managed file: $TARGET"
echo "- Make sure your Lazy.nvim configuration includes this file so the theme is loaded."
echo "- To switch themes immediately without restarting Neovim, run:"
echo "    $SCRIPT_DIR/change_theme.sh <your-theme-slug>"
echo
echo "Done."
