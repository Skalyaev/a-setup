return {

    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/nvim-cmp" },
    lazy = true,
    event = "BufReadPre",
    init = function()

        vim.g.markdown_fenced_languages = { "ts=typescript" }
    end,
    config = function()

        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        capabilities.textDocument.foldingRange = {

            dynamicRegistration = false,
            lineFoldingOnly = true
        }
        local cnf = require("lspconfig")
        cnf.util.default_config = vim.tbl_extend(

            "force", cnf.util.default_config,
            { capabilities = capabilities }
        )
        cnf.lua_ls.setup(require("lsp.lua"))
        cnf.bashls.setup(require("lsp.bash"))
        cnf.rust_analyzer.setup(require("lsp.rust"))
        cnf.ccls.setup(require("lsp.c"))
        cnf.pyright.setup(require("lsp.python.pyright"))
        cnf.ruff.setup(require("lsp.python.ruff"))
        cnf.denols.setup(require("lsp.javascript"))
        cnf.marksman.setup(require("lsp.markdown"))
        cnf.dockerls.setup(require("lsp.docker"))
    end
}
