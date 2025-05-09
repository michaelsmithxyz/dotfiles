return {
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'use' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
    },
  },
}
