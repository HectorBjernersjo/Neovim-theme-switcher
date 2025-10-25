SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

echo "Welcome to my custom neovim theme switcher"
echo "Make sure that you include $NVIM_THEME_FILE in your neovim config, otherwise this won't work"
if [ -e "$NVIM_THEME_FILE" ]; then
    echo "You already seem to have a theme.lua there, if this is from running this script, then good, you don't need to rerun it, otherwise remove it and rerun this install script"
else 
    echo "Symlinking $SCRIPT_DIR/theme.lua to $NVIM_THEME_FILE"
    ln -sf $SCRIPT_DIR/theme.lua $NVIM_THEME_FILE
fi

echo "$SCRIPT_DIR/change_theme.sh \$1 >> $OMARCHY_THEME_HOOK_FILE"
