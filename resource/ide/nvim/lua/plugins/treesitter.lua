return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufRead",
    config = function ()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "lua", "vim", "vimdoc" },
            sync_install = false,
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
 }
