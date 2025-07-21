# 🔧 NvChad Troubleshooting Guide

This guide covers common NvChad misconfigurations and provides step-by-step solutions to diagnose and fix them.

## 📋 Quick Diagnostic Commands

Before diving into specific issues, run these commands in Neovim to gather diagnostic information:

```vim
:checkhealth                    " Overall health check
:LspInfo                       " Check active LSP clients
:Mason                         " Check installed tools
:Lazy                         " Check plugin status
:set filetype?                " Check current filetype
:lua print(vim.inspect(require("core.utils").load_config()))  " Check config
```

---

## 1. 🔍 LSP Setup Not Attaching Properly

### Symptoms
- `:LspInfo` shows no active clients
- No autocompletion, hover, or goto definition
- No diagnostics appearing

### Diagnostic Steps

#### Step 1: Check if LSP client should be active
```vim
:LspInfo
```
Expected output should show active clients like `pyright` and `ruff` for Python files.

#### Step 2: Verify file type detection
```vim
:set filetype?
```
For Python files, this should return `filetype=python`.

#### Step 3: Check Mason installations
```vim
:Mason
```
Verify that required servers are installed:
- `pyright` (Python language server)
- `ruff` (Python linter/formatter)
- `debugpy` (Python debugger)

#### Step 4: Check LSP configuration
Open your `configs/lspconfig.lua` and verify:

```lua
-- Check that servers are properly configured
local lspconfig = require("lspconfig")

-- Ruff should be configured
lspconfig.ruff.setup({
  on_attach = custom_on_attach,
  capabilities = capabilities,
  filetypes = {"python"},  -- Make sure this matches your file type
})

-- Pyright should be configured  
lspconfig.pyright.setup({
  on_attach = custom_on_attach,
  capabilities = capabilities,
  filetypes = {"python"},  -- Make sure this matches your file type
})
```

### Solutions

#### Fix 1: Missing Mason installations
```vim
:MasonInstall pyright ruff debugpy mypy
```

#### Fix 2: Incorrect filetypes configuration
Update your `configs/lspconfig.lua`:
```lua
-- Ensure filetypes match exactly
filetypes = {"python"},  -- Not "py" or "Python"
```

#### Fix 3: on_attach function issues
Verify your `on_attach` function is properly defined:
```lua
local custom_on_attach = function(client, bufnr)
  -- Call the original on_attach function first
  on_attach(client, bufnr)
  
  -- Add your custom functionality here
end
```

#### Fix 4: Capabilities issues
Ensure capabilities are properly configured:
```lua
local config = require("plugins.configs.lspconfig")
local capabilities = config.capabilities

-- Ensure consistent position encoding
if capabilities.general then
  capabilities.general.positionEncodings = { "utf-8" }
end
```

#### Fix 5: Restart LSP client
```vim
:LspRestart
```

---

## 2. 🔄 Plugin Conflicts or Double Loading

### Symptoms
- Plugins not loading correctly
- Error messages about duplicate plugins
- Unexpected behavior or crashes

### Diagnostic Steps

#### Step 1: Check Lazy.nvim status
```vim
:Lazy
```
Look for:
- Duplicate entries
- Failed installations
- Circular dependencies

#### Step 2: Check plugin configurations
Review your `plugins.lua` for:
- Duplicate plugin specifications
- Conflicting configurations
- Missing dependencies

### Solutions

#### Fix 1: Remove duplicate plugin entries
Check `plugins.lua` for duplicate entries:
```lua
-- BAD: Duplicate entries
{
  "neovim/nvim-lspconfig",
  config = function() ... end
},
{
  "neovim/nvim-lspconfig",  -- Duplicate!
  opts = { ... }
}

-- GOOD: Single entry with merged config
{
  "neovim/nvim-lspconfig",
  opts = { ... },
  config = function() ... end
}
```

#### Fix 2: Fix circular dependencies
Ensure proper dependency order:
```lua
-- BAD: Circular dependency
{
  "plugin-a",
  dependencies = { "plugin-b" }
},
{
  "plugin-b", 
  dependencies = { "plugin-a" }  -- Circular!
}

-- GOOD: Proper dependency hierarchy
{
  "plugin-a",
  dependencies = { "plugin-b" }
},
{
  "plugin-b"  -- No circular dependency
}
```

#### Fix 3: Clean and reinstall
```vim
:Lazy clean
:Lazy sync
```

---

## 3. ⚙️ Custom Overrides Breaking Modules

### Symptoms
- Error messages about deprecated functions
- UI elements not displaying correctly
- Keymaps not working

### Diagnostic Steps

#### Step 1: Check for deprecated function calls
Look for these common deprecated patterns in your custom files:

```lua
-- Deprecated patterns to avoid:
require("core.utils").load_mappings()  -- Old mapping system
vim.g.theme = "theme_name"            -- Old theme setting
require("custom.chadrc").ui.statusline -- Direct statusline access
```

#### Step 2: Validate chadrc.lua structure
Your `chadrc.lua` should follow this structure:
```lua
---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "theme_name",
  -- other ui options
}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

return M
```

### Solutions

#### Fix 1: Update deprecated function calls
Replace old patterns:
```lua
-- OLD (deprecated)
require("core.utils").load_mappings("dap")

-- NEW (correct)
-- Mappings are loaded automatically from M.mappings in chadrc.lua
```

#### Fix 2: Fix statusline overrides
```lua
-- OLD (may break)
M.ui.statusline = {
  overrides = {
    -- direct modifications
  }
}

-- NEW (safer)
-- Use NvChad's official statusline customization methods
-- or extend through proper plugin configuration
```

#### Fix 3: Update mapping structure
Ensure your `mappings.lua` follows the correct structure:
```lua
local M = {}

M.dap = {
  plugin = true,  -- Important: mark as plugin mapping
  n = {
    ["<leader>db"] = {"<cmd> DapToggleBreakpoint <CR>", "Toggle breakpoint"}
  }
}

return M
```

---

## 4. 🔧 None-ls Integration Quirks

### Symptoms
- Black, mypy, or ruff not working despite Mason installation
- No formatting happening on save
- Linting not showing diagnostics

### Diagnostic Steps

#### Step 1: Check $PATH and tool availability
```bash
# In terminal, check if tools are accessible
which ruff
which mypy
which black

# Check Mason installation path
ls ~/.local/share/nvim/mason/packages/
```

#### Step 2: Check LSP vs None-ls configuration
Modern NvChad configurations should use LSP servers directly rather than none-ls:

```lua
-- MODERN (recommended): Use Ruff's built-in LSP
lspconfig.ruff.setup({
  on_attach = custom_on_attach,
  capabilities = capabilities,
})

-- OLD (deprecated): none-ls configuration
-- null_ls.builtins.formatting.ruff
```

### Solutions

#### Fix 1: Migrate from none-ls to native LSP
Update your `configs/lspconfig.lua` to use native LSP servers:

```lua
-- Use Ruff's native LSP server instead of none-ls
lspconfig.ruff.setup({
  on_attach = custom_on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
})

-- Configure Pyright for type checking
lspconfig.pyright.setup({
  on_attach = custom_on_attach,
  capabilities = capabilities,
  settings = {
    pyright = {
      disableOrganizeImports = true,  -- Let Ruff handle this
    },
  },
})
```

#### Fix 2: Fix format on save
Ensure your format on save is properly configured:
```lua
local custom_on_attach = function(client, bufnr)
  on_attach(client, bufnr)
  
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting", {}),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ 
          bufnr = bufnr,
          filter = function(c)
            return c.name == "ruff"  -- Only use Ruff for formatting
          end
        })
      end,
    })
  end
end
```

#### Fix 3: Reinstall tools via Mason
```vim
:MasonUninstall ruff mypy black
:MasonInstall ruff mypy
```

---

## 5. 📄 Neovim Filetype Detection Errors

### Symptoms
- `:set filetype?` returns unexpected values
- LSP not attaching to files
- Syntax highlighting not working

### Diagnostic Steps

#### Step 1: Check current filetype
```vim
:set filetype?
```

#### Step 2: Check file extension and content
```vim
:echo expand('%:e')          " File extension  
:echo &filetype              " Current filetype
:lua print(vim.bo.filetype)  " Lua way to check filetype
```

#### Step 3: Check filetype detection
```vim
:set filetype=python         " Manually set filetype
:LspInfo                     " Check if LSP attaches now
```

### Solutions

#### Fix 1: Force filetype detection
```vim
" Manually set filetype for current buffer
:set filetype=python

" Or add to your init configuration
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = {"*.py", "*.pyi"},
  callback = function()
    vim.bo.filetype = "python"
  end,
})
```

#### Fix 2: Fix file associations
Add to your `chadrc.lua` or init configuration:
```lua
-- Ensure proper filetype detection
vim.filetype.add({
  extension = {
    py = 'python',
    pyi = 'python',
    -- Add other extensions as needed
  },
  filename = {
    ['requirements.txt'] = 'requirements',
    ['Pipfile'] = 'toml',
  },
  pattern = {
    ['.*%.py$'] = 'python',
  },
})
```

#### Fix 3: Reset filetype detection
```vim
:filetype off
:filetype on
:filetype plugin indent on
```

---

## 🚀 Quick Fixes Checklist

When you encounter issues, try these quick fixes in order:

1. **Restart Neovim completely**
2. **Check basic commands:**
   ```vim
   :checkhealth
   :LspInfo  
   :Mason
   :Lazy
   ```
3. **Reinstall tools:**
   ```vim
   :Lazy clean
   :Lazy sync
   :MasonInstallAll
   ```
4. **Restart LSP:**
   ```vim
   :LspRestart
   ```
5. **Check file type:**
   ```vim
   :set filetype?
   :set filetype=python  " or appropriate type
   ```

---

## 🆘 Still Having Issues?

If you're still experiencing problems after following this guide:

1. **Create a minimal reproduction case**
2. **Run `:checkhealth` and share the output**
3. **Share your configuration files** (`chadrc.lua`, `plugins.lua`, `configs/lspconfig.lua`)
4. **Include error messages** from `:messages`

Remember: Most NvChad issues are configuration-related and can be resolved by carefully checking the configuration structure and ensuring all dependencies are properly installed.