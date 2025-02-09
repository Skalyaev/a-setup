return {

    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/nvim-cmp" },
    init = function()

        vim.g.markdown_fenced_languages = { "ts=typescript" }
        --  Required for 'denols' language server
    end,
    config = function()

        local cnf = require("lspconfig")
        local cmp = require("cmp_nvim_lsp")

        local capabilities = cmp.default_capabilities()
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
