#!/usr/bin/env bash
set -euo pipefail

# --- Resolve paths and configuration ---
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Bring in NVIM_THEME_FILE and OMARCHY_THEME_HOOK_FILE from config.sh
source "$SCRIPT_DIR/config.sh"

if [[ -z "${NVIM_THEME_FILE:-}" ]]; then
    echo "Error: NVIM_THEME_FILE is not set. Please set it in config.sh"
    exit 1
fi

# Expand '~' if present
TARGET="${NVIM_THEME_FILE/#\~/$HOME}"

echo "== Neovim Theme Switcher – Installation =="
echo
echo "1) Installing theme.lua file into your Neovim config."
echo "   Target file: $TARGET"
echo "   You should include this file somewhere in your lazy config as you would any other plugins."
echo

# Ensure parent directory exists
PARENT_DIR="$(dirname "$TARGET")"
if [[ ! -d "$PARENT_DIR" ]]; then
    echo "The directory $PARENT_DIR does not exist so we can't put theme.lua there"
    exit 1
fi

# --- Symlink theme.lua into place ---
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
    HOOK_FILE="${OMARCHY_THEME_HOOK_FILE/#\~/$HOME}"

    echo "   Do you want to append a hook to: $HOOK_FILE?"
    read -r -p "   This will make it so that neovim changes themes automatically when omarchy does [y/N]" hook_input
    if [[ "$hook_input" =~ ^[Yy]$ ]]; then
        mkdir -p "$(dirname "$HOOK_FILE")"
        touch "$HOOK_FILE"

      # This is the line Omarchy should call with the theme slug as $1
      HOOK_LINE="$SCRIPT_DIR/switch \"\$1\""

      if grep -Fqx -- "$HOOK_LINE" "$HOOK_FILE"; then
          echo "   Hook already present in: $HOOK_FILE"
      else
          printf '%s\n' "$HOOK_LINE" >> "$HOOK_FILE"
          chmod +x "$HOOK_FILE" || true
          echo "   Added hook to: $HOOK_FILE"
          echo "   → $HOOK_LINE"
      fi
  else 
      echo "Skipping appending hook, you can add it yourself if you want to"
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
