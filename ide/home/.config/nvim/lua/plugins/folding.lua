return {

    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    lazy = true,
    event = "BufEnter",
    config = function ()

        vim.o.foldlevel = 42
        vim.o.foldlevelstart = 42
        vim.o.foldcolumn = '1'

        local ufo = require("ufo")
        ufo.setup({ open_fold_hl_timeout = 200 })

        vim.keymap.set('n', 'ze', ufo.openFoldsExceptKinds)
        vim.keymap.set('n', 'za', ufo.closeFoldsWith)
        vim.keymap.set('n', '<leader>ze', ufo.openAllFolds)
        vim.keymap.set('n', '<leader>za', ufo.closeAllFolds)
    end
    --PROBLEM: autoformat causes unfolding
}
