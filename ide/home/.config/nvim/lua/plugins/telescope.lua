return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {

            "nvim-lua/plenary.nvim",
            "nvim-lua/popup.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()

            local telescope = require("telescope")
            local find_files = {

                follow = true,
                hidden = true,
                no_ignore = true,
                no_ignore_parent = true
            }
            local pickers = { find_files = find_files }

            telescope.setup({ pickers = pickers })
            telescope.load_extension("fzf")
            telescope.load_extension("media_files")


            local builtin = require("telescope.builtin")
            vim.keymap.set("n", "<leader>f", builtin.find_files, {})
            vim.keymap.set("n", "<leader>g", builtin.live_grep, {})
            vim.keymap.set("n", "<leader>to", builtin.oldfiles, {})
            vim.keymap.set("n", "<leader>tb", builtin.buffers, {})
            vim.keymap.set("n", "<leader>tr", builtin.registers, {})
            vim.keymap.set("n", "<leader>tk", builtin.keymaps, {})
            vim.keymap.set("n", "<leader>tc", builtin.commands, {})
            vim.keymap.set("n", "<leader>tv", builtin.vim_options, {})
            vim.keymap.set("n", "<leader>tgs", builtin.grep_string, {})
            vim.keymap.set("n", "<leader>tm", ":Telescope media_files<CR>")
        end
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = 'make'
    },
    {
        "nvim-telescope/telescope-media-files.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" }
    }
}
