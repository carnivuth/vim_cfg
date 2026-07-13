return {
  "hrsh7th/nvim-cmp",

  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-emoji',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',

  },
  event = "InsertEnter",

  config = function()
    local cmp =require("cmp")
    cmp.setup({

      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },

      mapping = require("cmp").mapping.preset.insert({
        ['<C-d>'] = require("cmp").mapping.scroll_docs(-4),
        ['<C-f>'] = require("cmp").mapping.scroll_docs(4),
        ['<C-Space>'] = require("cmp").mapping.complete(),
        ['<CR>'] = require("cmp").mapping.confirm {
          behavior = require("cmp").ConfirmBehavior.Replace,
          select = true,
        },

        ['<Tab>'] = require("cmp").mapping(function(fallback)
          if require("cmp").visible() then
            require("cmp").select_next_item()
          elseif require("luasnip").expand_or_jumpable() then
            require("luasnip").expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = require("cmp").mapping(function(fallback)
          if require("cmp").visible() then
            require("cmp").select_prev_item()
          elseif require("luasnip").jumpable(-1) then
            require("luasnip").jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      }),
      sources = require("cmp").config.sources({
        { name = 'copilot' },
        { name = 'nvim_lsp' },
        { name = 'emoji' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
        { name = "parrot" },
        { name = "ygoprodeck" },
      }),
    })
    cmp.setup.filetype("tex", {
      sources = {
        { name = 'vimtex' },
        { name = 'buffer' },
      },
    })
  end
}

