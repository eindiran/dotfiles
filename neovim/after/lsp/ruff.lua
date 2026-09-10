-- ruff server: ty owns hover and syntax errors, so both are switched off here.
return {
    init_options = { settings = { showSyntaxErrors = false } },
    on_attach = function(client)
        client.server_capabilities.hoverProvider = false
    end,
}
