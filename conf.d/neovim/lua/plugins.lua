local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    PackerInstalled = fn.system({
      'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path,
    })
    vim.api.nvim_command('packadd packer.nvim')
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()
local packer = require('packer')

return packer.startup({
  function(use)

    -- ---------------------------------------------------------------------
    -- plugin manager
    -- ---------------------------------------------------------------------

    use({
      'wbthomason/packer.nvim',
      config = function()
        vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
          pattern = { 'plugins.lua' },
          callback = function()
            vim.api.nvim_command('source <afile>')
            require('packer').compile()
          end,
        })
      end,
    })

    -- ---------------------------------------------------------------------
    -- appearance
    -- ---------------------------------------------------------------------

    use({
      'folke/tokyonight.nvim',
      config = function()
        require('tokyonight').setup({
          style = 'night',
          styles = {
            comments = { italic = false },
            keywords = { italic = false },
          },
          transparent = true,
        })
        vim.api.nvim_command('colorscheme tokyonight')
      end,
    })

    use({
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons' },
      config = function()
        require('lualine').setup({
          options = {
            icon_enabled = true,
            disable_filetype = {},
          },
          sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch' },
            lualine_c = {
              { 'filename', file_status = true, path = 0 },
            },
            lualine_x = {
              {
                'diagnostics',
                source = { 'nvim_diagnostic' },
                symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
              },
              'encoding',
              'filetype',
            },
            lualine_y = { 'progress' },
            lualine_z = { 'location' },
          },
          inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {
              { 'filename', file_status = true, path = 1 },
            },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {},
          },
          tabline = {},
        })
      end,
    })

    use({
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('colorizer').setup()
      end,
    })

    -- ---------------------------------------------------------------------
    -- git
    -- ---------------------------------------------------------------------

    use('tpope/vim-fugitive')

    use({
      'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = function()
        local gs = require('gitsigns')
        gs.setup({
          on_attach = function(bufnr)
            local keymap = function(mode, l, r, opts)
              opts = opts or {}
              opts.buffer = bufnr
              vim.keymap.set(mode, l, r, opts)
            end

            keymap('n', '[git]m', function() gs.blame_line({ full = true }) end)
            keymap('n', '[git]n', function()
              if not vim.wo.diff then
                vim.schedule(gs.next_hunk)
                return '<Ignore>'
              end
            end, { expr = true })
            keymap('n', '[git]p', function()
              if not vim.wo.diff then
                vim.schedule(gs.prev_hunk)
                return '<Ignore>'
              end
            end, { expr = true })
            keymap('n', '[git]v', gs.preview_hunk)
          end,
        })
      end,
    })

    use({
      'kdheepak/lazygit.nvim',
      setup = function()
        vim.g.lazygit_floating_window_winblend = 0
        vim.g.lazygit_floating_window_scaling_factor = 0.8
        vim.g.lazygit_use_neovim_remote = 0
        vim.keymap.set('n', '[git]g', '<cmd>LazyGit<cr>')
      end,
    })

    -- ---------------------------------------------------------------------
    -- tools
    -- ---------------------------------------------------------------------

    use({
      'simeji/winresizer',
      setup = function()
        vim.g.winresizer_vert_resize = 1
        vim.g.winresizer_horiz_resize = 1
        vim.keymap.set('n', '<c-w>r', '<cmd>WinResizerStartResize<cr>')
      end,
    })

    use({
      'akinsho/toggleterm.nvim',
      config = function()
        require('toggleterm').setup({
          open_mapping = '<c-z>',
          direction = 'float',
          shade_terminals = true,
          float_opts = {
            border = 'curved',
            winblend = 0,
            highlights = {
              background = 'Normal',
              border = 'Normal',
            },
          },
        })
      end,
    })

    -- ---------------------------------------------------------------------
    -- tree sitter
    -- ---------------------------------------------------------------------

    use({
      'nvim-treesitter/nvim-treesitter',
      run = function()
        require('nvim-treesitter.install').update({ with_sync = true })
      end,
      config = function()
        local config = require('nvim-treesitter.configs')
        config.setup({
          auto_install = true,
          autotag = {
            enable = true,
          },
          context_commentstring = {
            enable = true,
          },
          endwise = {
            enable = true,
          },
          ensure_installed = {
            'bash',
            'css',
            'dockerfile',
            'graphql',
            'html',
            'javascript',
            'json',
            'lua',
            'markdown',
            'tsx',
            'typescript',
          },
          highlight = {
            enable = true,
            disable = {},
          },
          indent = {
            enable = true,
            disable = { 'css', 'graphql', 'html', 'javascript', 'json', 'lua', 'tsx', 'typescript' },
            -- disable = { 'css', 'graphql', 'html', 'javascript', 'json', 'typescript' },
          },
          yati = {
            enable = true,
            -- suppress_conflict_warning = true,
          },
        })
      end,
    })

    use({
      'yioneko/nvim-yati',
      -- tag = '*',
      after = { 'nvim-treesitter' },
    })

    use({
      'nvim-treesitter/nvim-treesitter-context',
      after = { 'nvim-treesitter' },
      config = function()
        require('treesitter-context').setup()
      end,
    })

    use({
      'haringsrob/nvim_context_vt',
      after = { 'nvim-treesitter' },
      config = function()
        require('nvim_context_vt').setup()
      end,
    })

    use({
      'nvim-treesitter/nvim-treesitter-textobjects',
      after = { 'nvim-treesitter' },
    })

    use({
      'JoosepAlviste/nvim-ts-context-commentstring',
      after = { 'nvim-treesitter' },
    })

    use({
      'RRethy/nvim-treesitter-endwise',
      after = { 'nvim-treesitter' },
    })

    use({
      'windwp/nvim-ts-autotag',
      after = { 'nvim-treesitter' },
    })

    -- ---------------------------------------------------------------------
    -- LSP
    -- ---------------------------------------------------------------------

    use({
      'neovim/nvim-lspconfig',
      requires = {
        'b0o/schemastore.nvim',
        'folke/lsp-colors.nvim',
      },
      config = function()
        local lspconfig = require('lspconfig')
        local autocmd = vim.api.nvim_create_autocmd

        local protocol = require('vim.lsp.protocol')
        protocol.CompletionItemKind = {
          '', -- Text
          '', -- Method
          '', -- Function
          '', -- Constructor
          '', -- Field
          '', -- Variable
          '', -- Class

          '', -- Module
          '', -- Property
          '', -- Unit
          '', -- Value
          '', -- Enum
          '', -- Keyword
          '', -- Snippet
          '', -- Color
          '', -- File
          '', -- Reference
          '', -- Folder
          '', -- EnumMember
          '', -- Constant
          '', -- Struct
          '', -- Event

          '', -- TypeParameter
        }

        local capabilities = require('cmp_nvim_lsp').default_capabilities()

        vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
          vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            update_in_insert = false,
            virtual_text = { spacing = 4, prefix = '●' },
            severity_sort = true,
          }
        )

        local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
        for type, icon in pairs(signs) do
          local hl = "DiagnosticSign" .. type
          vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
        end

        vim.diagnostic.config({
          virtual_text = {
            prefix = '●'
          },
          update_in_insert = true,
          float = {
            source = "always", -- Or "if_many"
          },
        })

        local servers = {
          dockerls = {},
          eslint = {},
          jsonls = {
            settings = {
              json = {
                schemas = require('schemastore').json.schemas(),
                validate = {
                  enable = true,
                },
              },
            },
          },
          sumneko_lua = {
            settings = {
              Lua = {
                completion = {
                  keywordSnippet = 'Disable',
                },
                diagnostics = {
                  globals = { 'vim' },
                  disable = { 'lowercase-global' },
                },
                runtime = {
                  version = 'LuaJIT',
                  path = vim.split(package.path, ';'),
                },
                workspace = {
                  library = {
                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                  },
                },
              },
            },
          },
          tailwindcss = {},
          tsserver = {},
        }

        lspconfig.util.default_config = vim.tbl_extend('force',
          lspconfig.util.default_config, { capabilities = capabilities })

        for server, options in pairs(servers) do
          lspconfig[server].setup(options)
        end

        vim.keymap.set('n', '[lsp]F', vim.lsp.buf.formatting)

        autocmd({ 'BufWritePre' }, {
          pattern = { '*.tsx', '*.ts', '*.jsx', '*.js' },
          command = 'EslintFixAll',
        })
        autocmd({ 'BufWritePre' }, {
          pattern = { '*.json' },
          callback = function()
            vim.lsp.buf.format()
          end
        })
      end,
    })

    use({
      'williamboman/mason.nvim',
      requires = { 'williamboman/mason-lspconfig.nvim' },
      config = function()
        require('mason').setup()
        require('mason-lspconfig').setup({
          ensure_installed = {
            'dockerls',
            'eslint',
            'jsonls',
            'sumneko_lua',
            'tailwindcss',
            'tsserver',
          },
        })
      end,
    })

    use({
      'glepnir/lspsaga.nvim',
      branch = 'main',
      setup = function()
        local keymap = vim.keymap.set
        keymap('n', 'K',      '<cmd>Lspsaga hover_doc<cr>')
        keymap('n', '<c-k>',  '<cmd>Lspsaga signature_help<cr>')
        keymap('n', '[lsp]R', '<cmd>Lspsaga rename<cr>')
        keymap('n', '[lsp]c', '<cmd>Lspsaga code_action<cr>')
        keymap('n', '[lsp]f', '<cmd>Lspsaga code_action<cr>')
        keymap('n', '[lsp]n', '<cmd>Lspsaga diagnostic_jump_next<cr>')
        keymap('n', '[lsp]p', '<cmd>Lspsaga diagnostic_jump_prev<cr>')
        keymap('n', '[lsp]v', '<cmd>Lspsaga preview_definition<cr>')
      end,
      config = function()
        require('lspsaga').init_lsp_saga()
      end
    })

    use({
      'j-hui/fidget.nvim',
      config = function()
        require('fidget').setup()
      end
    })

    -- ---------------------------------------------------------------------
    -- auto completion
    -- ---------------------------------------------------------------------

    use({
      'onsails/lspkind-nvim',
      config = function()
        require('lspkind').init({
          mode = 'symbol',
          preset = 'codicons',
          symbol_map = {
            Text = "",
            Method = "",
            Function = "",
            Constructor = "",
            Field = "ﰠ",
            Variable = "",
            Class = "ﴯ",
            Interface = "",
            Module = "",
            Property = "ﰠ",
            Unit = "塞",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "פּ",
            Event = "",
            Operator = "",
            TypeParameter = ""
          },
        })
      end,
    })

    use({
      'hrsh7th/nvim-cmp',
      requires = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'hrsh7th/cmp-cmdline',
        'hrsh7th/vim-vsnip',
      },
      after = { 'lspkind-nvim' },
      config = function()
        local cmp = require('cmp')

        vim.g.vsnip_snippet_dir = vim.fn.stdpath('config') .. '/vsnip'

        local has_words_before = function()
          local line, col = unpack(vim.api.nvim_win_get_cursor(0))
          return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
        end

        local feedkey = function(key, mode)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
        end

        cmp.setup({
          snippet = {
            expand = function(args)
              vim.fn["vsnip#anonymous"](args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ['<c-b>'] = cmp.mapping.scroll_docs(-4),
            ['<c-f>'] = cmp.mapping.scroll_docs(4),
            ["<Tab>"] = cmp.mapping(
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif vim.fn["vsnip#available"](1) == 1 then
                  feedkey("<Plug>(vsnip-expand-or-jump)", "")
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
                end
              end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(
              function()
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                  feedkey("<Plug>(vsnip-jump-prev)", "")
                end
              end, { "i", "s" }),
            ['<c-space>'] = cmp.mapping.complete(),
            ['<c-e>'] = cmp.mapping.abort(),
            ['<cr>'] = cmp.mapping.confirm({ select = true }),
          }),
          sources = cmp.config.sources({
            { name = 'nvim_lsp' },
            { name = 'nvim_lue' },
            { name = 'vsnip' },
          }, {
            { name = 'buffer' },
          }),
          formatting = {
            format = require('lspkind').cmp_format({
              mode = 'symbol',
              maxwidth = 50,
              before = function(_, vim_item)
                return vim_item
              end,
            }),
          },
        })

        cmp.setup.cmdline('/', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' },
          },
        })

        cmp.setup.cmdline(':', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = cmp.config.sources({
            { name = 'path' },
          }, {
            { name = 'cmdline' },
          }),
        })
      end,
    })

    use({
      'hrsh7th/cmp-vsnip',
      after = { 'nvim-cmp' },
    })

    --
    -- utility
    --

    use('tpope/vim-commentary')
    use('tpope/vim-surround')
    use('machakann/vim-sandwich')

    use({
      'windwp/nvim-autopairs',
      config = function()
        local status, autopairs = pcall(require, 'nvim-autopairs')
        if not status then
          return
        end

        local escape_pair = function()
          local closers = {
            ')', ']', '}', "'", '>', '"','`', ','
          }
          local line = vim.api.nvim_get_current_line()
          local row, col = unpack(vim.api.nvim_win_get_cursor(0))
          local after = line:sub(col + 1, -1)
          local closer_col = #after + 1
          local closer_i = nil
          for i, closer in ipairs(closers) do
            local cur_index, _ = after:find(closer)
            if cur_index and (cur_index < closer_col) then
              closer_col = cur_index
              closer_i = i
            end
          end
          if closer_i then
            vim.api.nvim_win_set_cursor(0, { row, col + closer_col })
          else
            vim.api.nvim_win_set_cursor(0, { row, col + 1 })
          end
        end

        require('nvim-autopairs').setup({
          check_ts = true,
          map_c_h = true,
          ts_config = {
            lua = { 'string' },
          },
        })

        local ts_conds = require('nvim-autopairs.ts-conds')
        local Rule = require('nvim-autopairs.rule')

        autopairs.add_rules({
          Rule('%', '%', 'lua'):with_pair(ts_conds.is_ts_node({ 'string', 'comment' })),
          Rule('$', '$', 'lua'):with_pair(ts_conds.is_ts_node({ 'string', 'function' })),
        })

        vim.keymap.set('i', '<c-l>', escape_pair)
      end,
    })

    use({
      'phaazon/hop.nvim',
      setup = function()
        local keymap = vim.keymap.set
        keymap('n', '[search]f', '<cmd>HopChar2<cr>')
        keymap('n', '[search]l', '<cmd>HopLine<cr>')
        keymap('n', '[search]w', '<cmd>HopWord<cr>')
      end,
      config = function()
        require('hop').setup({
          key = 'dhtnsbmwvzfgcrlaoeuipyqjkx',
        })
      end,
    })

    -- ---------------------------------------------------------------------
    -- fuzzy finding
    -- ---------------------------------------------------------------------

    use({
      'nvim-telescope/telescope.nvim',
      requires = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-file-browser.nvim',
        'nvim-telescope/telescope-packer.nvim',
        'nvim-telescope/telescope-github.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make',
        },
      },
      config = function()
        local telescope = require('telescope')
        local actions = require('telescope.actions')
        local fb_actions = require('telescope').extensions.file_browser.actions

        telescope.setup({
          defaults = {
            file_ignore_pattern = { '.git', 'node_modules' },
            mappings = {
              n = {
                ['q'] = actions.close,
              },
            },
          },
          pickers = {
            buffers = {
              sort_lastused = true,
              mappings = {
                i = {
                  ['<c-d>'] = actions.delete_buffer,
                },
                n = {
                  ['dd'] = actions.delete_buffer,
                },
              },
            },
          },
          extensions = {
            file_browser = {
              hijack_netrw = true,
              mappings = {
                ['n'] = {
                  ['<c-c>'] = actions.close,
                  ['^'] = fb_actions.goto_home_dir,
                  ['q'] = actions.close
                },
              },
            },
            fzf = {
              fuzzy = true,
              override_generic_sorter = false,
              override_file_sorter = true,
              case_mode = 'smart_case',
            },
          },
        })

        telescope.load_extension('file_browser')
        telescope.load_extension('fzf')
        telescope.load_extension('packer')
        telescope.load_extension('gh')

        local builtin = require('telescope.builtin')
        local keymap = vim.keymap.set
        keymap('n', '<leader><leader>', builtin.commands)
        keymap('n', '<leader>/',        builtin.live_grep)
        keymap('n', '[buffer]b',        builtin.buffers)
        keymap('n', '[execute]r',       builtin.command_history)
        keymap('n', '[file]f', function()
          telescope.extensions.file_browser.file_browser({
            path = '%:p:h',
            cwd = vim.fn.expand('%:p:h'),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
          })
        end)
        keymap('n', '[file]r',          builtin.oldfiles)
        keymap('n', '[git]b',           builtin.git_branches)
        keymap('n', '[git]l',           builtin.git_commits)
        keymap('n', '[help]h',          builtin.help_tags)
        keymap('n', '[lsp]d',           builtin.lsp_definitions)
        keymap('n', '[lsp]i',           builtin.lsp_implementations)
        keymap('n', '[lsp]l',           builtin.diagnostics)
        keymap('n', '[lsp]r',           builtin.lsp_references)
        keymap('n', '[lsp]s',           builtin.lsp_workspace_symbols)
        keymap('n', '[lsp]t',           builtin.lsp_type_definitions)
        keymap('n', '[project]f',       builtin.git_files)
        keymap('n', '[search]r',        builtin.search_history)
        keymap('n', '[search]s',        builtin.current_buffer_fuzzy_find)
      end,
    })

    -- ---------------------------------------------------------------------
    -- bootstrap
    -- ---------------------------------------------------------------------

    if packer_bootstrap then
      packer.sync()
    end

  end,

  config = {
    display = {
      open_fn = function()
        local result, win, buf = require('packer.util').float({
          border = {
            { '╭', 'FloatBorder' },
            { '─', 'FloatBorder' },
            { '╮', 'FloatBorder' },
            { '│', 'FloatBorder' },
            { '╯', 'FloatBorder' },
            { '─', 'FloatBorder' },
            { '╰', 'FloatBorder' },
            { '│', 'FloatBorder' },
          },
        })
        vim.api.nvim_win_set_option(win, 'winhighlight', 'NormalFloat:Normal')
        return result, win, buf
      end,
    },
  },
})
