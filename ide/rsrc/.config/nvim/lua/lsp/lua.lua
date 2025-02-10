return {

    settings = { Lua = {} },
    on_init = function(client)

        local library = {

            vim.env.VIMRUNTIME,
            "${3rd}/luv/library",
            "${3rd}/busted/library"
        }
        local workspace = {

            library = library,
            checkThirdParty = false
        }
        local runtime = { version = "LuaJIT" }
        client.config.settings.Lua = vim.tbl_deep_extend(

            "force", client.config.settings.Lua,
            { runtime = runtime, workspace = workspace }
        )
    end
}
