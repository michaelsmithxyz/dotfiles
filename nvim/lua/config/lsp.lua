vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    local builtin = require('telescope.builtin')

    map('<leader>gd', builtin.lsp_definitions, '[G]oto [D]efinition')
    map('<leader>gt', builtin.lsp_type_definitions, '[G]oto [T]ype Definition')

    map('<leader>sr', function()
      builtin.lsp_references({ show_line = false })
    end, '[S]how [R]eferences')
    map('<leader>ss', builtin.lsp_document_symbols, '[S]how Document [S]ymbols')
    map('<leader>sS', builtin.lsp_workspace_symbols, '[S]how Workspace [S]ymbols')
    map('<leader>sd', function()
      builtin.diagnostics({ bufnr = 0 })
    end, '[S]how [D]iagnostics')
    map('<leader>sa', vim.lsp.buf.code_action, '[S]how Code [A]ctions')
    map('<leader>si', builtin.lsp_implementations, '[S]how [I]mplementations')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

local signs = { ERROR = '', WARN = '', INFO = '', HINT = '' }
local diagnostic_signs = {}
for type, icon in pairs(signs) do
  diagnostic_signs[vim.diagnostic.severity[type]] = icon
end
vim.diagnostic.config({
  signs = { text = diagnostic_signs, virtual_text = true },
})

local ensure_installed = {
  'eslint',
  'tsgo',
  'denols',
  'lua_ls',
  'omnisharp',
  'clangd',
  'pyright',
  'harper_ls',
}

if vim.fn.executable('go') == 1 then
  table.insert(ensure_installed, 'gopls')
end

require('mason').setup()
require('mason-lspconfig').setup({
  automatic_enable = {
    -- ts_ls's package may still be installed; tsgo replaces it.
    exclude = { 'ts_ls' },
  },
  ensure_installed = ensure_installed,
})
