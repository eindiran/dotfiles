--[[
FILE: lua/user/format.lua
DESCRIPTION: Formatting through conform.nvim. Format on save is on by default: =af
toggles it globally, :FormatDisable[!] and :FormatEnable control it per buffer (bang) or
globally, =aF formats on demand. Filetypes without a listed formatter only get trailing
whitespace and trailing blank lines trimmed. Go, Rust, and C format through their
language servers (gofmt via gopls, rustfmt via rust-analyzer, clang-format via clangd).
--]]
local map = vim.keymap.set
local conform = require("conform")

local function autoformat_disabled(buf)
    return vim.g.disable_autoformat or vim.b[buf].disable_autoformat
end

-- gopls organize-imports on save. Created before conform.setup() so this BufWritePre
-- autocmd runs first; conform's LSP format (gofmt) then runs on the result.
vim.api.nvim_create_autocmd("BufWritePre", {
    group = vim.api.nvim_create_augroup("UserGoOrganizeImports", { clear = true }),
    pattern = "*.go",
    callback = function(args)
        if autoformat_disabled(args.buf) then
            return
        end
        for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf, name = "gopls" })) do
            local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
            params.context = { only = { "source.organizeImports" }, diagnostics = {} }
            local res = client:request_sync("textDocument/codeAction", params, 2000, args.buf)
            for _, action in ipairs(res and res.result or {}) do
                if action.edit then
                    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
                end
            end
        end
    end,
})

conform.setup({
    formatters_by_ft = {
        python = { "ruff_organize_imports", "ruff_format" },
        sh = { "shfmt" },
        bash = { "shfmt" },
        lua = { "stylua" },
        zig = { "zigfmt" },
        go = { lsp_format = "prefer" },
        rust = { lsp_format = "prefer" },
        c = { lsp_format = "prefer" },
        cpp = { lsp_format = "prefer" },
        ["_"] = { "trim_whitespace", "trim_newlines" },
    },
    formatters = {
        -- Same flags ALE passed; any printer flag makes shfmt ignore .editorconfig
        shfmt = { prepend_args = { "-i", "4", "-ln", "bash", "-ci", "-kp" } },
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function(bufnr)
        if autoformat_disabled(bufnr) then
            return
        end
        -- The "_" trimmers would strip patch context lines
        local ft = vim.bo[bufnr].filetype
        if ft == "diff" or ft == "gitcommit" then
            return
        end
        return { timeout_ms = 1500 }
    end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, { desc = "Disable format on save (! for this buffer only)", bang = true })

vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, { desc = "Re-enable format on save" })

map("n", "=af", function()
    vim.g.disable_autoformat = not vim.g.disable_autoformat
    vim.notify("Format on save " .. (vim.g.disable_autoformat and "disabled" or "enabled"))
end, { silent = true, desc = "Toggle format on save" })

map("n", "=aF", function()
    conform.format({ async = true })
end, { silent = true, desc = "Format buffer now" })
