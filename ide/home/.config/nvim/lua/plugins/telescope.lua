local telescope_fzf_native = {

    "nvim-telescope/telescope-fzf-native.nvim",
    build = 'make',
    lazy = true,
}
local telescope = {

    "nvim-telescope/telescope.nvim",
    dependencies = {

        "nvim-lua/plenary.nvim",
        "nvim-lua/popup.nvim",
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
        "nvim-telescope/telescope-fzf-native.nvim"
    },
    lazy = true,
    cmd = "Telescope",
    init = function()

        vim.keymap.set("n", "<leader>f", ":Telescope find_files<CR>")
        vim.keymap.set("n", "<leader>g", ":Telescope live_grep<CR>")
        vim.keymap.set("n", "<leader>t", ":Telescope ")
        vim.keymap.set("n", "<leader>to", ":Telescope oldfiles<CR>")
        vim.keymap.set("n", "<leader>tm", ":Telescope media_files<CR>")
        vim.keymap.set("n", "<leader>tr", ":Telescope registers<CR>")
        vim.keymap.set("n", "<leader>th", ":Telescope highlights<CR>")
        vim.keymap.set("n", "<leader>tt", ":Telescope resume<CR>")
    end,
    config = function()

        local telescope = require("telescope")

        local borders = { "─", "│", "─", "│", "┌", "┐", "┘", "└" }
        local defaults = { borderchars = borders }

        local find_files = {

            follow = true,
            hidden = true,
            no_ignore = true,
            no_ignore_parent = true
        }
        local pickers = { find_files = find_files }
        telescope.setup({

            defaults = defaults,
            pickers = pickers
        })
        telescope.load_extension("fzf")
        telescope.load_extension("media_files")
    end
}
local telescope_media_files = {

    "nvim-telescope/telescope-media-files.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    lazy = true,
    cmd = "Telescope media_files"
}
return {

    telescope_fzf_native,
    telescope,
    telescope_media_files
}
