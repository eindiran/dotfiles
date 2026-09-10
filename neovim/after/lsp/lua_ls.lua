-- lua-language-server diagnostics. lazydev.nvim supplies the Neovim runtime types; the
-- vim global is kept so nothing is undefined before lazydev has loaded.
return {
    settings = {
        Lua = {
            diagnostics = {
                disable = { "incomplete-signature-doc" },
                globals = { "MiniMap", "vim" },
            },
        },
    },
}
