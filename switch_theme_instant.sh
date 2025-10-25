#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then 
  echo "Usage: $(basename "$0") <theme-name>"
  exit 1
fi

theme="$1"

# Map your human-friendly slug -> actual :colorscheme name
declare -A themes=(
  ["catppuccin-latte"]="catppuccin-latte"
  ["catppuccin"]="catppuccin"
  ["everforest"]="everforest"
  ["flexoki-light"]="flexoki-light"
  ["gruvbox"]="gruvbox"
  ["kanagawa"]="kanagawa"
  ["matte-black"]="matteblack"
  ["nord"]="nordfox"
  ["osaka-jade"]="bamboo"
  ["ristretto"]="monokai-pro"
  ["rose-pine"]="rose-pine-dawn"
  ["tokyo-night"]="tokyonight-night"
)

# Per-theme background preference
# Use "light" or "dark" (themes that ignore it won’t break)
declare -A bg=(
  ["catppuccin-latte"]="light"
  ["catppuccin"]="dark"
  ["everforest"]="dark"
  ["flexoki-light"]="light"
  ["gruvbox"]="dark"
  ["kanagawa"]="dark"
  ["matte-black"]="dark"
  ["nord"]="dark"
  ["osaka-jade"]="dark"
  ["ristretto"]="dark"
  ["rose-pine"]="light"
  ["tokyo-night"]="dark"
)

if [[ -z "${themes[$theme]:-}" ]]; then
  echo "theme does not exist"
  exit 1
fi

cs="${themes[$theme]}"
b="${bg[$theme]:-dark}"  # sane default

# Find all running headless UI sockets; skip if none
shopt -s nullglob
files=(/run/user/1000/nvim.*)
shopt -u nullglob

if ((${#files[@]} == 0)); then
  echo "No Neovim servers found — not changing theme."
  exit 0
fi

for file in "${files[@]}"; do
  nvim --server "$file" --remote-send ":set background=${b}<CR>:colorscheme ${cs}<CR>"
done

echo "✅ Applied ${theme} (${cs}) with ${b} background to ${#files[@]} instance(s)."
