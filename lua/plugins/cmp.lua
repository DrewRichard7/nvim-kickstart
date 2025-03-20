return {
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    enabled = false,
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          -- `friendly-snippets` contains a variety of premade snippets.
          --    See the README about individual language/framework/plugin snippets:
          --    https://github.com/rafamadriz/friendly-snippets
          -- {
          --   'rafamadriz/friendly-snippets',
          --   config = function()
          --     require('luasnip.loaders.from_vscode').lazy_load()
          --   end,
          -- },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp-signature-help',
    },
    config = function()
      -- See `:help cmp`
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = { completeopt = 'menu,menuone,noinsert' },

        -- For an understanding of why these mappings were
        -- chosen, you will need to read `:help ins-completion`
        --
        -- No, but seriously. Please read `:help ins-completion`, it is really good!
        mapping = cmp.mapping.preset.insert {
          -- Select the [n]ext item
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- Select the [p]revious item
          ['<C-p>'] = cmp.mapping.select_prev_item(),

          -- Scroll the documentation window [b]ack / [f]orward
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),

          -- Accept ([y]es) the completion.
          --  This will auto-import if your LSP supports it.
          --  This will expand snippets if the LSP sent a snippet.
          ['<C-y>'] = cmp.mapping.confirm { select = true },

          -- If you prefer more traditional completion keymaps,
          -- you can uncomment the following lines
          --['<CR>'] = cmp.mapping.confirm { select = true },
          --['<Tab>'] = cmp.mapping.select_next_item(),
          --['<S-Tab>'] = cmp.mapping.select_prev_item(),

          -- Manually trigger a completion from nvim-cmp.
          --  Generally you don't need this, because nvim-cmp will display
          --  completions whenever it has completion options available.
          ['<C-Space>'] = cmp.mapping.complete {},

          -- Think of <c-l> as moving to the right of your snippet expansion.
          --  So if you have a snippet that's like:
          --  function $name($args)
          --    $body
          --  end
          --
          -- <c-l> will move you to the right of each of the expansion locations.
          -- <c-h> is similar, except moving you backwards.
          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),

          -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        },
        sources = {
          {
            name = 'lazydev',
            -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
            group_index = 0,
          },
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          { name = 'nvim_lsp_signature_help' },
        },
      }
    end,
  },
  --
  { -- completion
    'hrsh7th/nvim-cmp',
    enabled = true,
    event = 'InsertEnter',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-emoji',
      'saadparwaiz1/cmp_luasnip',
      'f3fora/cmp-spell',
      'ray-x/cmp-treesitter',
      'kdheepak/cmp-latex-symbols',
      'jmbuhr/cmp-pandoc-references',
      'L3MON4D3/LuaSnip',
      'rafamadriz/friendly-snippets',
      'onsails/lspkind-nvim',
      'jmbuhr/otter.nvim',
    },
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lspkind = require 'lspkind'

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        -- change noinsert to noselect for no autocomplete
        completion = { completeopt = 'menu,menuone,noinsert' }, -------- autocomplete
        mapping = {
          ['<C-f>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),

          ['<C-n>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-p>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<c-y>'] = cmp.mapping.confirm {
            select = true,
          },
          ['<CR>'] = cmp.mapping.confirm {
            select = true,
          },

          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            else
              fallback()
            end
          end, { 'i', 's' }),

          ['<C-l>'] = cmp.mapping(function()
            if luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            end
          end, { 'i', 's' }),
          ['<C-h>'] = cmp.mapping(function()
            if luasnip.locally_jumpable(-1) then
              luasnip.jump(-1)
            end
          end, { 'i', 's' }),
        },
        autocomplete = false,

        ---@diagnostic disable-next-line: missing-fields
        formatting = {
          format = lspkind.cmp_format {
            mode = 'symbol',
            menu = {
              otter = '[🦦]',
              nvim_lsp = '[LSP]',
              nvim_lsp_signature_help = '[sig]',
              luasnip = '[snip]',
              buffer = '[buf]',
              path = '[path]',
              spell = '[spell]',
              pandoc_references = '[ref]',
              tags = '[tag]',
              treesitter = '[TS]',
              calc = '[calc]',
              latex_symbols = '[tex]',
              emoji = '[emoji]',
            },
          },
        },
        sources = {
          { name = 'otter' }, -- for code chunks in quarto
          { name = 'path' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lsp' },
          { name = 'luasnip', keyword_length = 3, max_item_count = 3 },
          { name = 'pandoc_references' },
          { name = 'buffer', keyword_length = 5, max_item_count = 3 },
          { name = 'spell' },
          { name = 'treesitter', keyword_length = 5, max_item_count = 3 },
          { name = 'calc' },
          { name = 'latex_symbols' },
          { name = 'emoji' },
        },
        view = {
          entries = 'native',
        },
        window = {
          documentation = {
            border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
            -- border = require('misc.style').border, -- this is from quarto config
          },
        },
      }

      -- for friendly snippets
      require('luasnip.loaders.from_vscode').lazy_load()
      -- for custom snippets
      require('luasnip.loaders.from_vscode').lazy_load { paths = { vim.fn.stdpath 'config' .. '/snips' } }
      -- link quarto and rmarkdown to markdown snippets
      luasnip.filetype_extend('quarto', { 'markdown' })
      luasnip.filetype_extend('rmarkdown', { 'markdown' })
    end,
  },
}

-- config condensed and created by gemini 2.0 flash:
-- return {
--   { -- Autocompletion
--     'hrsh7th/nvim-cmp',
--     enabled = true,
--     event = 'InsertEnter',
--     dependencies = {
--       -- Snippet Engine & its associated nvim-cmp source
--       {
--         'L3MON4D3/LuaSnip',
--         build = (function()
--           -- Build Step is needed for regex support in snippets.
--           -- This step is not supported in many windows environments.
--           -- Remove the below condition to re-enable on windows.
--           if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
--             return
--           end
--           return 'make install_jsregexp'
--         end)(),
--         dependencies = {
--           -- `friendly-snippets` contains a variety of premade snippets.
--           --    See the README about individual language/framework/plugin snippets:
--           --    https://github.com/rafamadriz/friendly-snippets
--           {
--             'rafamadriz/friendly-snippets',
--             config = function()
--               require('luasnip.loaders.from_vscode').lazy_load()
--             end,
--           },
--         },
--       },
--       'saadparwaiz1/cmp_luasnip',
--
--       -- Adds other completion capabilities.
--       --  nvim-cmp does not ship with all sources by default. They are split
--       --  into multiple repos for maintenance purposes.
--       'hrsh7th/cmp-nvim-lsp',
--       'hrsh7th/cmp-path',
--       'hrsh7th/cmp-nvim-lsp-signature-help',
--       'hrsh7th/cmp-buffer',
--       'hrsh7th/cmp-calc',
--       'hrsh7th/cmp-emoji',
--       'f3fora/cmp-spell',
--       'ray-x/cmp-treesitter',
--       'kdheepak/cmp-latex-symbols',
--       'jmbuhr/cmp-pandoc-references',
--       'onsails/lspkind-nvim',
--       'jmbuhr/otter.nvim',
--     },
--     config = function()
--       -- See `:help cmp`
--       local cmp = require 'cmp'
--       local luasnip = require 'luasnip'
--       local lspkind = require 'lspkind'
--       luasnip.config.setup {}
--
--       local has_words_before = function()
--         local line, col = unpack(vim.api.nvim_win_get_cursor(0))
--         return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match '%s' == nil
--       end
--
--       cmp.setup {
--         snippet = {
--           expand = function(args)
--             luasnip.lsp_expand(args.body)
--           end,
--         },
--         -- This setting prevents completion on Enter
--         completion = { completeopt = 'menu,menuone,noinsert' },
--
--         -- For an understanding of why these mappings were
--         -- chosen, you will need to read `:help ins-completion`
--         --
--         -- No, but seriously. Please read `:help ins-completion`, it is really good!
--         mapping = cmp.mapping.preset.insert {
--           -- Select the [n]ext item
--           ['<C-n>'] = cmp.mapping(function(fallback)
--             if luasnip.expand_or_jumpable() then
--               luasnip.expand_or_jump()
--             else
--               fallback()
--             end
--           end, { 'i', 's' }),
--           -- Select the [p]revious item
--           ['<C-p>'] = cmp.mapping(function(fallback)
--             if luasnip.jumpable(-1) then
--               luasnip.jump(-1)
--             else
--               fallback()
--             end
--           end, { 'i', 's' }),
--
--           -- Scroll the documentation window [b]ack / [f]orward
--           ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--           ['<C-f>'] = cmp.mapping.scroll_docs(4),
--
--           -- Accept ([y]es) the completion.
--           --  This will auto-import if your LSP supports it.
--           --  This will expand snippets if the LSP sent a snippet.
--           ['<C-y>'] = cmp.mapping.confirm { select = true },
--
--           -- If you prefer more traditional completion keymaps,
--           -- you can uncomment the following lines
--           --['<CR>'] = cmp.mapping.confirm { select = true },
--           --['<Tab>'] = cmp.mapping.select_next_item(),
--           --['<S-Tab>'] = cmp.mapping.select_prev_item(),
--
--           -- Manually trigger a completion from nvim-cmp.
--           --  Generally you don't need this, because nvim-cmp will display
--           --  completions whenever it has completion options available.
--           ['<C-Space>'] = cmp.mapping.complete {},
--
--           -- Think of <c-l> as moving to the right of your snippet expansion.
--           --  So if you have a snippet that's like:
--           --  function $name($args)
--           --    $body
--           --  end
--           --
--           -- <c-l> will move you to the right of each of the expansion locations.
--           -- <c-h> is similar, except moving you backwards.
--           ['<C-l>'] = cmp.mapping(function()
--             if luasnip.expand_or_locally_jumpable() then
--               luasnip.expand_or_jump()
--             end
--           end, { 'i', 's' }),
--           ['<C-h>'] = cmp.mapping(function()
--             if luasnip.locally_jumpable(-1) then
--               luasnip.jump(-1)
--             end
--           end, { 'i', 's' }),
--
--           -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
--           --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
--           ['<Tab>'] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--               cmp.select_next_item()
--             elseif has_words_before() then
--               cmp.complete()
--             else
--               fallback()
--             end
--           end, { 'i', 's' }),
--           ['<S-Tab>'] = cmp.mapping(function(fallback)
--             if cmp.visible() then
--               cmp.select_prev_item()
--             else
--               fallback()
--             end
--           end, { 'i', 's' }),
--           ['<C-e>'] = cmp.mapping.abort(),
--           -- ['<CR>'] = function(fallback)
--           --   fallback() -- Just insert a newline
--           -- end,
--         },
--
--         ---@diagnostic disable-next-line: missing-fields
--         formatting = {
--           format = lspkind.cmp_format {
--             mode = 'symbol',
--             menu = {
--               otter = '[🦦]',
--               nvim_lsp = '[LSP]',
--               nvim_lsp_signature_help = '[sig]',
--               luasnip = '[snip]',
--               buffer = '[buf]',
--               path = '[path]',
--               spell = '[spell]',
--               pandoc_references = '[ref]',
--               tags = '[tag]',
--               treesitter = '[TS]',
--               calc = '[calc]',
--               latex_symbols = '[tex]',
--               emoji = '[emoji]',
--               lazydev = '[lazydev]',
--             },
--           },
--         },
--         sources = {
--           {
--             name = 'lazydev',
--             -- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
--             group_index = 0,
--           },
--           { name = 'otter' }, -- for code chunks in quarto
--           { name = 'path' },
--           { name = 'nvim_lsp_signature_help' },
--           { name = 'nvim_lsp' },
--           { name = 'luasnip', keyword_length = 3, max_item_count = 3 },
--           { name = 'pandoc_references' },
--           { name = 'buffer', keyword_length = 5, max_item_count = 3 },
--           { name = 'spell' },
--           { name = 'treesitter', keyword_length = 5, max_item_count = 3 },
--           { name = 'calc' },
--           { name = 'latex_symbols' },
--           { name = 'emoji' },
--         },
--         view = {
--           entries = 'native',
--         },
--         window = {
--           documentation = {
--             border = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
--             -- border = require('misc.style').border, -- this is from quarto config
--           },
--         },
--       }
--
--       -- for friendly snippets
--       require('luasnip.loaders.from_vscode').lazy_load()
--       -- for custom snippets
--       require('luasnip.loaders.from_vscode').lazy_load { paths = { vim.fn.stdpath 'config' .. '/snips' } }
--       -- link quarto and rmarkdown to markdown snippets
--       luasnip.filetype_extend('quarto', { 'markdown' })
--       luasnip.filetype_extend('rmarkdown', { 'markdown' })
--     end,
--   },
-- }
