return {

    "preservim/nerdtree",
    lazy = true,
    cmd = "NERDTreeToggle",
    init = function()

        vim.g.NERDTreeWinSize = 20
        vim.g.NERDTreeShowHidden = 1
        vim.g.NERDTreeMinimalUI = 1
        vim.g.NERDTreeChDirMode = 3
        vim.g.NERDTreeCascadeSingleChildDir = 0

        vim.keymap.set("n", "²", ":NERDTreeToggle<CR>")
        vim.keymap.set("n", "~", ":NERDTreeFocus<CR>")
    end
}
