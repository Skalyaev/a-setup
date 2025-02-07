return {

    "Skalyaev/a-nvim-theme",
    priority = 42,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()

        vim.cmd([[colorscheme neon]])
    end
}
