return {
    "sbdchd/neoformat",
    event = "BufRead",
    config = function()
        vim.api.nvim_create_autocmd("BufWritePre", {
            pattern = "*",
            command = "Neoformat",
        })
        vim.g.neoformat_basic_format_retab = 1
        vim.g.neoformat_basic_format_trim = 1
        vim.g.neoformat_try_node_exe = 1
    end
}
