return {
    "vim-autoformat/vim-autoformat",
    event = "BufRead",
    config = function()
        vim.g.autoformat_autoindent = 0
        vim.api.nvim_command('autocmd BufWrite * Autoformat')
    end
}
