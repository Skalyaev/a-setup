local library = {

    vim.env.VIMRUNTIME,
    "${3rd}/luv/library",
    "${3rd}/busted/library"
}
local workspace = {

    library = library,
    checkThirdParty = false
}
return {

    settings = { Lua = {} },
    on_init = function(client)

        client.config.settings.Lua = vim.tbl_deep_extend(

            "force", client.config.settings.Lua,
            { workspace = workspace }
        )
    end
}
