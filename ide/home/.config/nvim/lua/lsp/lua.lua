return {

    settings = { Lua = {} },
    on_init = function(client)

        local runtime = { version = "LuaJIT" }
        local workspace = {

            library = {

                vim.env.VIMRUNTIME,
                "${3rd}/luv/library",
                "${3rd}/busted/library"
            },
            checkThirdParty = false
        }
        client.config.settings.Lua = vim.tbl_deep_extend(

            "force", client.config.settings.Lua,
            { runtime = runtime, workspace = workspace }
        )
    end
}
