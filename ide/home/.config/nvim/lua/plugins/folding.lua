return {

    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function ()

        vim.o.foldcolumn = '1'
        vim.o.foldlevel = 42
        vim.o.foldlevelstart = 42
        vim.o.foldenable = true

        local ufo = require("ufo")
        ufo.setup({})

        vim.keymap.set("n", "<leader>+", ufo.openAllFolds)
        vim.keymap.set("n", "<leader>-", ufo.closeAllFolds)
    end
}
