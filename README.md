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
├── chadrc.lua           # Main NvChad configuration entry point
├── plugins.lua          # Custom plugin specifications
├── mappings.lua         # Additional keybindings for custom features
├── README.md           # This file
└── configs/
    ├── lspconfig.lua   # LSP server configurations
    └── none-ls.lua     # Formatting and linting setup
```

## 🎨 Theme & UI

- **Theme**: Catppuccin - A soothing pastel theme perfect for long coding sessions
- **Philosophy**: Clean, distraction-free interface that enhances focus

## 🔌 Key Plugin Extensions

### Development Tools
- **nvim-dap** + **nvim-dap-ui**: Full debugging support with intuitive UI
- **nvim-dap-python**: Python-specific debugging capabilities
- **none-ls**: Code formatting and linting integration

### Language Support
- **Pyright**: Advanced Python language server for type checking and IntelliSense
- **Ruff LSP**: Lightning-fast Python linter and formatter
- **Mason Integration**: Automatic tool installation and management

### Code Quality Tools
- **Black**: Uncompromising Python code formatter
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
- **Ruff LSP**: Fast linting and code analysis
- **Auto-completion**: Intelligent code completion powered by LSP

### Code Formatting & Linting
- **Auto-format on save**: Black formatter runs automatically on Python files
- **Type checking**: Mypy integration with virtual environment detection
- **Real-time diagnostics**: Immediate feedback on code issues

### Debugging Workflow
1. Set breakpoints with `<leader>db`
2. Start debugging session
3. UI automatically opens with variable inspection, call stack, and controls
4. Test-specific debugging with `<leader>dpr` for Python test methods

## 🛠️ Mason Tool Management

Automatically installs and manages:
- `black` - Code formatter
- `debugpy` - Python debugger
- `mypy` - Type checker
- `ruff-lsp` - Fast linter
- `pyright` - Language server

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

## 📝 Notes

- This configuration is built on top of NvChad v2.0
- Focuses primarily on Python development but can be easily extended
- Maintains the clean, fast philosophy of NvChad while adding powerful development tools
- All configurations follow NvChad conventions for easy maintenance and updates

---

*Happy coding! 🚀*
