# 🌌 NvChad Custom Configuration

Welcome to my personal NvChad customization! This setup extends the NvChad base configuration with focused enhancements for Python development, debugging, and productivity.

## 🧠 Philosophy

This custom configuration is tailored for:
- **Python-first development** with robust LSP and debugging support
- **Clean code practices** with automated formatting and linting
- **Streamlined debugging workflow** with DAP integration
- **Minimal yet powerful** extensions to the NvChad base

## 🗂️ Structure Overview

```bash
~/.config/nvim/lua/custom/
├── chadrc.lua            # Main NvChad configuration entry point
├── plugins.lua           # Custom plugin specifications
├── mappings.lua          # Additional keybindings for custom features
├── README.md            # This file
├── TROUBLESHOOTING.md   # Common issues and solutions guide
└── configs/
    ├── lspconfig.lua    # LSP server configurations with auto-formatting
    └── diagnostics.lua  # Configuration diagnostic tool
```

## 🎨 Theme & UI

- **Theme**: Catppuccin - A soothing pastel theme perfect for long coding sessions
- **Philosophy**: Clean, distraction-free interface that enhances focus

## 🔌 Key Plugin Extensions

### Development Tools
- **nvim-dap** + **nvim-dap-ui**: Full debugging support with intuitive UI
- **nvim-dap-python**: Python-specific debugging capabilities  
- **Modern LSP**: Direct formatting and linting through Ruff's built-in LSP server

### Language Support
- **Pyright**: Advanced Python language server for type checking and IntelliSense
- **Ruff**: Lightning-fast Python linter and formatter with built-in LSP server
- **Mason Integration**: Automatic tool installation and management

### Code Quality Tools
- **Ruff**: Ultra-fast Python formatter and linter (replaces Black + Flake8)
- **Mypy**: Static type checker for Python
- **Debugpy**: Python debugger adapter

## ⌨️ Custom Keybindings

### Debugging (DAP)
| Key | Action | Mode |
|-----|--------|------|
| `<leader>db` | Toggle Breakpoint | Normal |
| `<leader>dpr` | Run Python Test Method | Normal |

*Note: Additional DAP keybindings are loaded automatically when debugging is active*

## 🐍 Python Development Features

### LSP Configuration
- **Pyright**: Comprehensive Python language support with type checking
- **Ruff**: Fast linting and code analysis with built-in LSP server
- **Auto-completion**: Intelligent code completion powered by LSP

### Code Formatting & Linting
- **Auto-format on save**: Ruff formatter runs automatically on Python files
- **Real-time linting**: Immediate feedback on code issues via Ruff LSP
- **Type checking**: Pyright provides comprehensive type analysis

### Debugging Workflow
1. Set breakpoints with `<leader>db`
2. Start debugging session
3. UI automatically opens with variable inspection, call stack, and controls
4. Test-specific debugging with `<leader>dpr` for Python test methods

## 🛠️ Mason Tool Management

Automatically installs and manages:
- `debugpy` - Python debugger
- `mypy` - Type checker (via none-ls legacy support)
- `ruff` - Ultra-fast linter and formatter with built-in LSP server
- `pyright` - Language server for type checking and IntelliSense

## � Getting Started

1. Ensure you have NvChad installed as your base configuration
2. This custom folder should already be in place at `~/.config/nvim/lua/custom/`
3. Run `:Lazy sync` to install custom plugins
4. Run `:MasonInstallAll` to install Python development tools
5. Restart Neovim and enjoy the enhanced Python development experience!

## 🔧 Customization Tips

- **Virtual Environments**: The configuration automatically detects `VIRTUAL_ENV` or `CONDA_PREFIX`
- **Additional Languages**: Extend `configs/lspconfig.lua` to add more language servers
- **Theme Changes**: Modify the theme in `chadrc.lua` (`M.ui.theme`)
- **Custom Keybindings**: Add new mappings in `mappings.lua`

## 🔍 Troubleshooting

Having issues with your NvChad configuration? We provide two tools to help:

### 📋 Comprehensive Troubleshooting Guide
Check out our **[Troubleshooting Guide](./TROUBLESHOOTING.md)** which covers:

- LSP setup not attaching properly
- Plugin conflicts or double loading  
- Custom overrides breaking modules
- None-ls integration quirks
- Neovim filetype detection errors

The guide includes step-by-step diagnostic commands and solutions for each common issue.

### 🔧 Automated Diagnostic Tool
Run the diagnostic tool to automatically check your configuration:

```vim
" Full diagnostic check
:lua require("custom.configs.diagnostics").run_all_checks()

" Individual checks (if you want to run specific checks)
:lua require("custom.configs.diagnostics").check_lsp_config()
:lua require("custom.configs.diagnostics").check_mason_tools()
:lua require("custom.configs.diagnostics").check_plugins()
```

This tool will check:
- ✅ Chadrc configuration structure
- ✅ Plugin installation status
- ✅ Mason tool installations
- ✅ LSP client status
- ✅ Filetype detection
- ✅ Format on save functionality

Example output:
```
🔍 NvChad Configuration Diagnostics

=== Chadrc Configuration Check ===
[PASS] custom.chadrc found
[PASS] UI configuration found
  Theme: github_dark
[PASS] Plugin configuration reference found
[PASS] Custom mappings found
```

## 📝 Notes

- This configuration is built on top of NvChad v2.0
- Focuses primarily on Python development but can be easily extended
- Maintains the clean, fast philosophy of NvChad while adding powerful development tools
- All configurations follow NvChad conventions for easy maintenance and updates

---

*Happy coding! 🚀*
