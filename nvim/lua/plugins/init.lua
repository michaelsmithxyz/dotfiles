return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    init = function()
      vim.opt.termguicolors = true
      vim.cmd.colorscheme('catppuccin-mocha')
    end,
  },
  'tpope/vim-sleuth',
  {
    'folke/which-key.nvim',
    event = 'VeryLazy',
    opts = {
      delay = 0,
    },
    keys = {},
  },
  {
    'akinsho/bufferline.nvim',
    config = true,
  },
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup({
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
        defaults = {
          path_display = {
            shorten = 3,
          },
        },
        pickers = {
          find_files = {
            find_command = { 'rg', '--files', '--hidden', '-g', '!.git' },
          },
        },
      })

      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>f', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>F', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>b', builtin.buffers, { desc = 'Buffers' })
      vim.keymap.set('n', '<leader>B', builtin.current_buffer_fuzzy_find, { desc = 'Current buffer' })
      vim.keymap.set('n', '<leader>j', builtin.jumplist, { desc = 'Jumplist' })
    end,
  },
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require('harpoon')
      harpoon:setup()

      local conf = require('telescope.config').values
      local function toggle_telescope(harpoon_files)
        local finder = function()
          local paths = {}
          for _, item in ipairs(harpoon_files.items) do
            table.insert(paths, item.value)
          end

          return require('telescope.finders').new_table({
            results = paths,
          })
        end

        require('telescope.pickers')
          .new({}, {
            prompt_title = 'Harpoon',
            finder = finder(),
            previewer = conf.file_previewer({}),
            sorter = conf.generic_sorter({}),
            attach_mappings = function(prompt_buffer_number, map)
              map('n', 'dd', function()
                local state = require('telescope.actions.state')
                local selected_entry = state.get_selected_entry()
                local current_picker = state.get_current_picker(prompt_buffer_number)

                table.remove(harpoon_files.items, selected_entry.index)
                current_picker:refresh(finder())
              end)

              return true
            end,
          })
          :find()
      end

      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'Add to harpoon' })
      vim.keymap.set('n', '<leader>l', function()
        toggle_telescope(harpoon:list())
      end, { desc = 'Open harpoon' })
    end,
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    opts = {},
  },
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 500,
      },
    },
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
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
        virtual_text = true,
        signs = { text = diagnostic_signs, virtual_text = true },
      })

      local ensure_installed = {
        'eslint',
        'ts_ls',
        'denols',
        'lua_ls',
        'omnisharp',
        'clangd',
        'pyright',
      }

      if vim.fn.executable('go') == 1 then
        table.insert(ensure_installed, 'gopls')
      end

      require('mason').setup()
      require('mason-lspconfig').setup({
        automatic_enable = true,
        ensure_installed = ensure_installed,
      })
    end,
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
    },
    config = function()
      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      require('ufo').setup()
    end,
  },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-buffer' },
  {
    'hrsh7th/nvim-cmp',
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert({
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<C-Tab>'] = cmp.mapping.complete({}),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'path' },
          { name = 'buffer' },
        },
        performance = {
          max_view_entries = 10,
          fetching_timeout = 1,
        },
      })
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
      'nvim-lua/lsp-status.nvim',
    },
    lazy = false,
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff' },
        lualine_c = {
          {
            'filename',
            newfile_status = true,
            path = 3,
            shorting_target = 20,
          },
        },
        lualine_x = { 'filetype', 'diagnostics' },
        lualine_y = {},
        lualine_z = { 'location' },
      },
    },
  },
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {},
    dependencies = {
      'MunifTanjim/nui.nvim',
    },
    config = function()
      require('noice').setup({
        lsp = {
          override = {
            ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
            ['vim.lsp.util.stylize_markdown'] = true,
            ['cmp.entry.get_documentation'] = true,
          },
        },
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true,
        },
      })
    end,
  },
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs',
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'html',
        'lua',
        'luadoc',
        'markdown',
        'markdown_inline',
        'query',
        'vim',
        'vimdoc',
      },
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = { enable = true },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {},
  },
  {
    'olimorris/codecompanion.nvim',
    opts = {},
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      local local_config = require('config.local').settings.codecompanion
      if not local_config then
        return
      end

      require('codecompanion').setup({
        display = {
          chat = {
            show_settings = true,
          },
        },
        strategies = {
          chat = {
            adapter = local_config.defaults.adapter,
          },
          inline = {
            adapter = local_config.defaults.adapter,
          },
        },
        adapters = local_config.adapters,
      })

      local adapters = {}
      for key, _ in pairs(local_config.adapters) do
        table.insert(adapters, key)
      end

      local t_pickers = require('telescope.pickers')
      local t_finders = require('telescope.finders')
      local t_config = require('telescope.config').values
      local t_actions = require('telescope.actions')
      local t_actions_state = require('telescope.actions.state')

      local adapter_picker = function(callback)
        t_pickers
          .new({}, {
            prompt_title = 'Select adapter',
            finder = t_finders.new_table({
              results = adapters,
            }),
            sorter = t_config.generic_sorter({}),
            attach_mappings = function(prompt_bufno)
              t_actions.select_default:replace(function()
                t_actions.close(prompt_bufno)
                callback(t_actions_state.get_selected_entry()[1])
              end)
              return true
            end,
          })
          :find()
      end

      vim.keymap.set(
        { 'n', 'v' },
        '<leader>c',
        '<cmd>CodeCompanionChat Toggle<cr>',
        { noremap = true, silent = true, desc = 'Toggle chat' }
      )
      vim.keymap.set({ 'n', 'v' }, '<leader>C', function()
        adapter_picker(function(adapter)
          vim.cmd(string.format('CodeCompanionChat %s', adapter))
        end)
      end, { noremap = true, silent = true, desc = 'Open chat with adapter' })
    end,
  },
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
  },
  {
    'ggandor/leap.nvim',
    opts = {},
    config = function()
      require('leap').set_default_mappings()
    end,
  },
}
