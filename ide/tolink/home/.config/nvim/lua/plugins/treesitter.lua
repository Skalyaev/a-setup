return {

    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = true,
    event = "BufEnter",
    config = function ()

        vim.cmd([[TSUpdate]])
        local settings = {

            highlight = { enable = true },
            indent = { enable = true },
            auto_install = true
        }
        require("nvim-treesitter.configs").setup(settings)
        local filename = {

            ['.bash_env'] = 'bash',
            ['.bash_welcome' ] = 'bash'
        }
        vim.filetype.add({ filename = filename })
    end
}
