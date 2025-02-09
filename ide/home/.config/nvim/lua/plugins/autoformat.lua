return {

    "vim-autoformat/vim-autoformat",
    lazy = true,
    cmd = "Autoformat",
    init = function() vim.cmd([[au BufWrite * :Autoformat]]) end
}
