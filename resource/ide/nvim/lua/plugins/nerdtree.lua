return {
    "preservim/nerdtree",
    cmd = "NERDTreeToggle",
    config = function()
        vim.g.NERDTreeShowHidden = 1
        vim.g.NERDTreeWinSize = 20
        vim.g.NERDTreeAutoCenter = 0
        vim.g.NERDTreeChDirMode = 3
        vim.g.NERDTreeMinimalUI = 1
        vim.g.NERDTreeCascadeSingleChildDir = 0
    end
}
