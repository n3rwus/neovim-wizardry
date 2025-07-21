-- NvChad Configuration Diagnostic Tool
-- Run this with: :luafile configs/diagnostics.lua

local M = {}

-- Color codes for output
local colors = {
  red = '\27[31m',
  green = '\27[32m',
  yellow = '\27[33m',
  blue = '\27[34m',
  reset = '\27[0m'
}

local function print_status(status, message)
  local color = status == "PASS" and colors.green or 
                status == "WARN" and colors.yellow or colors.red
  print(string.format("%s[%s]%s %s", color, status, colors.reset, message))
end

local function print_header(header)
  print(string.format("\n%s=== %s ===%s", colors.blue, header, colors.reset))
end

-- Check if a Mason package is installed
local function is_mason_package_installed(package)
  local mason_registry = require("mason-registry")
  return mason_registry.is_installed(package)
end

-- Check LSP configuration
function M.check_lsp_config()
  print_header("LSP Configuration Check")
  
  -- Check if lspconfig is available
  local has_lspconfig, lspconfig = pcall(require, "lspconfig")
  if not has_lspconfig then
    print_status("FAIL", "nvim-lspconfig not found")
    return
  end
  print_status("PASS", "nvim-lspconfig is available")
  
  -- Check if our custom lspconfig is loaded
  local has_custom_config = pcall(require, "custom.configs.lspconfig")
  if has_custom_config then
    print_status("PASS", "Custom LSP config found")
  else
    print_status("WARN", "Custom LSP config not found at custom.configs.lspconfig")
  end
  
  -- Check active LSP clients
  local clients = vim.lsp.get_active_clients()
  if #clients > 0 then
    print_status("PASS", string.format("Found %d active LSP clients", #clients))
    for _, client in pairs(clients) do
      print(string.format("  - %s (filetypes: %s)", client.name, 
            table.concat(client.config.filetypes or {}, ", ")))
    end
  else
    print_status("FAIL", "No active LSP clients found")
    print("  Try opening a Python file and running :LspInfo")
  end
end

-- Check Mason installations
function M.check_mason_tools()
  print_header("Mason Tools Check")
  
  local has_mason, mason = pcall(require, "mason")
  if not has_mason then
    print_status("FAIL", "Mason not installed")
    return
  end
  print_status("PASS", "Mason is available")
  
  local expected_tools = {"debugpy", "mypy", "ruff", "pyright"}
  
  for _, tool in ipairs(expected_tools) do
    if is_mason_package_installed(tool) then
      print_status("PASS", tool .. " is installed")
    else
      print_status("FAIL", tool .. " is not installed")
      print("  Run: :MasonInstall " .. tool)
    end
  end
end

-- Check plugin configuration
function M.check_plugins()
  print_header("Plugin Configuration Check")
  
  -- Check if lazy.nvim is available
  local has_lazy, lazy = pcall(require, "lazy")
  if not has_lazy then
    print_status("FAIL", "Lazy.nvim not found")
    return
  end
  print_status("PASS", "Lazy.nvim is available")
  
  -- Check our custom plugins
  local has_plugins, plugins = pcall(require, "custom.plugins")
  if has_plugins then
    print_status("PASS", "Custom plugins configuration found")
  else
    print_status("WARN", "Custom plugins configuration not found")
  end
  
  -- Check for common plugin issues
  local installed_plugins = lazy.plugins()
  local dap_found = false
  local lspconfig_found = false
  
  for name, plugin in pairs(installed_plugins) do
    if name:match("dap") then
      dap_found = true
    end
    if name:match("lspconfig") then
      lspconfig_found = true
    end
  end
  
  if dap_found then
    print_status("PASS", "DAP plugins found")
  else
    print_status("WARN", "No DAP plugins found")
  end
  
  if lspconfig_found then
    print_status("PASS", "LSP config plugin found")
  else
    print_status("FAIL", "LSP config plugin not found")
  end
end

-- Check file type detection
function M.check_filetype()
  print_header("Filetype Detection Check")
  
  local current_ft = vim.bo.filetype
  local current_file = vim.fn.expand("%")
  
  print(string.format("Current file: %s", current_file))
  print(string.format("Detected filetype: %s", current_ft or "none"))
  
  if current_file:match("%.py$") then
    if current_ft == "python" then
      print_status("PASS", "Python file correctly detected as python")
    else
      print_status("FAIL", "Python file not detected as python filetype")
      print("  Try: :set filetype=python")
    end
  else
    print_status("INFO", "Not a Python file, cannot check Python filetype detection")
  end
end

-- Check chadrc configuration
function M.check_chadrc()
  print_header("Chadrc Configuration Check")
  
  local has_chadrc, chadrc = pcall(require, "custom.chadrc")
  if not has_chadrc then
    print_status("FAIL", "custom.chadrc not found")
    return
  end
  
  print_status("PASS", "custom.chadrc found")
  
  -- Check structure
  if chadrc.ui then
    print_status("PASS", "UI configuration found")
    if chadrc.ui.theme then
      print(string.format("  Theme: %s", chadrc.ui.theme))
    end
  else
    print_status("WARN", "No UI configuration found")
  end
  
  if chadrc.plugins then
    print_status("PASS", "Plugin configuration reference found")
  else
    print_status("WARN", "No plugin configuration reference found")
  end
  
  if chadrc.mappings then
    print_status("PASS", "Custom mappings found")
  else
    print_status("WARN", "No custom mappings found")
  end
end

-- Check format on save functionality
function M.check_format_on_save()
  print_header("Format on Save Check")
  
  local current_buf = vim.api.nvim_get_current_buf()
  local autocommands = vim.api.nvim_get_autocmds({
    group = "LspFormatting",
    buffer = current_buf,
  })
  
  if #autocommands > 0 then
    print_status("PASS", "Format on save autocmd found for current buffer")
  else
    print_status("WARN", "No format on save autocmd found")
    print("  This might be normal if no LSP client with formatting is attached")
  end
end

-- Run all checks
function M.run_all_checks()
  print(string.format("%s🔍 NvChad Configuration Diagnostics%s\n", colors.blue, colors.reset))
  
  M.check_chadrc()
  M.check_plugins()
  M.check_mason_tools()
  M.check_lsp_config()
  M.check_filetype()
  M.check_format_on_save()
  
  print(string.format("\n%s✅ Diagnostic complete! Check any FAIL or WARN items above.%s", 
        colors.green, colors.reset))
  print(string.format("%sFor detailed solutions, see: TROUBLESHOOTING.md%s", 
        colors.yellow, colors.reset))
end

-- To auto-run, call M.run_all_checks() after requiring this module
-- Example: require("custom.configs.diagnostics").run_all_checks()

return M