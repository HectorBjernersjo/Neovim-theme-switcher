# Theme switcher for neovim
A lightweight theme switcher for Neovim that works with your own config, with or without Omarchy
.

## Using with Omarchy
I made this because i started using Omarchy and loved it. However, to have the theme switcher work i had to use lazyvim instead of my own neovim config which was a no go. I designed this theme switcher to work together with the omarchy theme switcher while working with your own neovim config. It also works completly fine without omarchy, then, to change the theme, you will need to manually call ./change_theme.sh \<your theme\>

## How it Works
- Creates a theme.lua file inside your Neovim config that selects the active colorscheme.
- When you switch themes, it uses Neovim’s RPC interface to update the colorscheme instantly — no restart required.
- If you’re using Omarchy, it automatically hooks into your Omarchy theme changes.

## Installation
- Edit config.sh and specify where you want your theme file to live
- Make sure to include this file in your lazy configuration
- Run the installation script (this will symlink the theme file and, if you're using omarchy) add a custom hook that automatically changes neovim theme when you change in omarchy.
- Restart neovim once
Then you should be good to go.

## Requirements
Even though the point is to avoid needing the LazyVim distribution, you are still required to use the lazy package manager for this to work.
