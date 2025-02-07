return {

    "vim-autoformat/vim-autoformat",
    lazy = true,
    event = "BufReadPost",
    config = function()

        vim.cmd([[au BufWrite * :Autoformat]])
    end
}
