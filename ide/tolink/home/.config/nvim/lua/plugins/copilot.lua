return {

    "github/copilot.vim",
    lazy = true,
    event = "BufEnter",
    config = function()

        vim.keymap.set("i", "<M-Down>", "<Plug>(copilot-next)")
        vim.keymap.set("i", "<M-Up>", "<Plug>(copilot-previous)")
        vim.keymap.set("i", "<M-Left>", "<Plug>(copilot-dismiss)")
    end
}
