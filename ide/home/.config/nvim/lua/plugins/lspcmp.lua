return {

    "hrsh7th/nvim-cmp",
    dependencies = {

        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        'hrsh7th/cmp-cmdline',
        "hrsh7th/cmp-vsnip",
        "hrsh7th/vim-vsnip"
    },
    config = function()

        vim.cmd([[set completeopt=menu,menuone,noselect]])

        local cmp = require("cmp")
        local snippet = {

            expand = function(args) vim.fn["vsnip#anonymous"](args.body) end
        }
        local mapping = cmp.mapping.preset.insert({

            ["Down"] = cmp.mapping.select_next_item(),
            ["Up"] = cmp.mapping.select_prev_item(),
            ["<C-Down>"] = cmp.mapping.scroll_docs(4),
            ["<C-Up>"] = cmp.mapping.scroll_docs(-4),
            ["<S-Tab>"] = cmp.mapping.confirm({ select = true }),
        })
        local sources = {

            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "vsnip" },
        }
        local window_cnf = cmp.config.window.bordered({ border = 'single' })
        local window = { completion = window_cnf, documentation = window_cnf }
        cmp.setup({

            snippet = snippet,
            mapping = mapping,
            sources = sources,
            window = window
        })
        local cmdline_mapping = cmp.mapping.preset.cmdline()
        cmp.setup.cmdline('/', {

            mapping = cmdline_mapping,
            sources = { { name = 'buffer' } }
        })
        cmp.setup.cmdline(':', {

            mapping = cmdline_mapping,
            sources = cmp.config.sources(

                { { name = 'path' } },
                { { name = 'cmdline' } }
            ),
            matching = { disallow_symbol_nonprefix_matching = false }
        })
    end
}
