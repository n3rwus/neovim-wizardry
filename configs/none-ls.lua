local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

-- Replace 'null-ls' with 'none-ls'
local none_ls = require("none-ls")

local opts = {
  sources = {
    none_ls.builtins.formatting.black,
    none_ls.builtins.diagnostics.mypy.with({
      extra_args = function()
        local virtual = os.getenv("VIRTUAL_ENV") or os.getenv("CONDA_PREFIX") or "/usr"
        return { "--python-executable", virtual .. "/bin/python3" }
      end,
    }),
  },
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({
        group = augroup,
        buffer = bufnr,
      })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
}

return opts
