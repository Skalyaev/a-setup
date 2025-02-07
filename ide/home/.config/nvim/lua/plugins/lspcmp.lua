return {

    "hrsh7th/nvim-cmp",
    dependencies = {

        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
    },
    lazy = true,
    event = "InsertEnter",
    config = function()

        local cmp = require("cmp")
        local mapping = cmp.mapping.preset.insert({

            ["Down"] = cmp.mapping.select_next_item(),
            ["Up"] = cmp.mapping.select_prev_item(),
            ["<CR>"] = cmp.mapping.confirm({

                behavior = require("cmp").ConfirmBehavior.Insert,
                select = true
            })
        })
        local sources = {

            { name = "nvim_lsp" },
            { name = "buffer" },
            { name = "path" },
        }
        local entries = { follow_cursor = true }
        local window = { side_padding = 4 }
        require("cmp").setup({

            mapping = mapping,
            sources = sources,
            entries = entries,
            window = window
        })
    end
}
