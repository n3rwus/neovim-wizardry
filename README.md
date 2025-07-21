# 🌌 Neovim Personal Configuration

Welcome to my custom Neovim configuration! This setup is designed to be clean, modular, and beginner-friendly while still leaving room for powerful workflows as I build it out.

## 🧠 Philosophy

This configuration is tailored for:
- Focused coding with minimal distractions
- Easy plugin management and extension
- Streamlined keybindings for efficiency
- Flexibility for experimenting and learning

## 🗂️ Structure Overview

```bash
~/.config/nvim/
├── init.lua          # Entry point, loads everything
├── lua/
│   ├── plugins.lua   # Plugin specs (lazy.nvim or packer)
│   ├── keymaps.lua   # Custom keybindings
│   ├── settings.lua  # General editor settings
│   └── ...           # Additional modules as I expand

