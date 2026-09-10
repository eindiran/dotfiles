--[[
FILE: lua/user/completion.lua
DESCRIPTION: blink.cmp options, returned as plain data. init.lua passes this table as
the plugin spec's opts so lazy.nvim still owns blink's lifecycle. super-tab preset: Tab
accepts, C-Space opens the menu or the docs, C-n/C-p move, C-e hides, C-k toggles
signature help.
--]]
return {
    keymap = { preset = "super-tab" },
    appearance = { nerd_font_variant = "mono" },
    completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = false },
    },
    signature = { enabled = true },
    sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
            -- Neovim runtime and plugin API types for Lua, via lazydev.nvim
            lazydev = {
                name = "LazyDev",
                module = "lazydev.integrations.blink",
                score_offset = 100,
            },
        },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
}
