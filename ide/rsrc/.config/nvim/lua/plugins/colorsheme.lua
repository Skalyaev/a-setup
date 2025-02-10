return {

    "Skalyaev/a-nvim-theme",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    priority = 42,
    config = function() vim.cmd([[colorscheme neon]]) end
}
