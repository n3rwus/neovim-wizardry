local config = require("plugins.configs.lspconfig")

local on_attach = config.on_attach
local capabilities = config.capabilities

-- Ensure consistent position encoding
if capabilities.general then
  capabilities.general.positionEncodings = { "utf-8" }
end

-- Custom on_attach function with format on save
local custom_on_attach = function(client, bufnr)
  -- Call the original on_attach function
  on_attach(client, bufnr)
  
  -- Enable format on save for Python files
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = vim.api.nvim_create_augroup("LspFormatting", {}),
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ 
          bufnr = bufnr,
          filter = function(c)
            -- Use Ruff for formatting, not Pyright
            return c.name == "ruff"
          end
        })
      end,
    })
  end
end

local lspconfig = require("lspconfig")

-- Configure Ruff LSP (built into ruff itself now)
lspconfig.ruff.setup({
  on_attach = custom_on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
})

-- Configure Pyright
lspconfig.pyright.setup({
  on_attach = custom_on_attach,
  capabilities = capabilities,
  filetypes = {"python"},
  settings = {
    pyright = {
      -- Using Ruff's import organizer, so disable Pyright's
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Let Ruff handle linting, keep Pyright for type checking
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "workspace",
      },
    },
  },
})
