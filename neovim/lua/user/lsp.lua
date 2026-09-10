--[[
FILE: lua/user/lsp.lua
DESCRIPTION: Language servers. Mason installs them, mason-lspconfig enables them,
nvim-lspconfig supplies cmd/filetypes/root markers, and per-server overrides live in
after/lsp/<server>.lua. Also owns the diagnostics display and the LSP keymaps.

Keymaps: =aj/=ak and <Leader>j/<Leader>k jump between diagnostics, =al opens the line
float, =ai runs the LSP health check, <F12> hides/shows diagnostics. Once a server is
attached: =ad definition, <Leader>h hover, =aa code action, =an rename, =ar references,
=ah inlay hints toggle. Neovim's built-in gr*, K, <C-]>, ]d/[d stay untouched. gd is not
used because fugitive owns gdh/gdl.
--]]
local M = {}

-- lspconfig names; mason-lspconfig maps them to Mason packages
M.servers = {
    "bashls",
    "clangd",
    "dockerls",
    "golangci_lint_ls",
    "gopls",
    "lua_ls",
    "ruff",
    "rust_analyzer",
    "ty",
    "zls",
}

local map = vim.keymap.set

-- Completion (blink.cmp) and folding capabilities, applied to every server
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities =
    vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities({}, false))
capabilities = vim.tbl_deep_extend("force", capabilities, {
    textDocument = {
        foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
    },
})
vim.lsp.config("*", { capabilities = capabilities })

require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = M.servers,
    automatic_enable = true,
})

vim.diagnostic.config({
    virtual_text = { source = "if_many" },
    signs = true,
    underline = true,
    severity_sort = true,
    update_in_insert = false,
    float = { source = "if_many" },
})

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
    callback = function(args)
        local buf = args.buf
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local function bmap(mode, lhs, rhs, desc)
            map(mode, lhs, rhs, { buffer = buf, silent = true, desc = desc })
        end
        bmap("n", "=ad", vim.lsp.buf.definition, "LSP: go to definition")
        bmap("n", "<Leader>h", vim.lsp.buf.hover, "LSP: hover")
        bmap({ "n", "x" }, "=aa", vim.lsp.buf.code_action, "LSP: code action")
        bmap("n", "=an", vim.lsp.buf.rename, "LSP: rename symbol")
        bmap("n", "=ar", vim.lsp.buf.references, "LSP: references")
        -- Hints start off; this only toggles them for the current buffer
        if client and client:supports_method("textDocument/inlayHint") then
            bmap("n", "=ah", function()
                local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = buf })
                vim.lsp.inlay_hint.enable(not enabled, { bufnr = buf })
            end, "LSP: toggle inlay hints")
        end
    end,
})

local function next_diagnostic()
    vim.diagnostic.jump({ count = 1, float = true })
end
local function prev_diagnostic()
    vim.diagnostic.jump({ count = -1, float = true })
end
map("n", "=aj", next_diagnostic, { silent = true, desc = "Next diagnostic" })
map("n", "<Leader>j", next_diagnostic, { silent = true, desc = "Next diagnostic" })
map("n", "=ak", prev_diagnostic, { silent = true, desc = "Previous diagnostic" })
map("n", "<Leader>k", prev_diagnostic, { silent = true, desc = "Previous diagnostic" })
map("n", "=al", vim.diagnostic.open_float, { silent = true, desc = "Line diagnostics" })
map("n", "=ai", "<Cmd>checkhealth vim.lsp<CR>", { silent = true, desc = "LSP health" })

-- <F12>: hide or show diagnostics without stopping them. =at in lint.lua is the
-- sticky off switch.
vim.g.diagnostics_active = true
map("n", "<F12>", function()
    vim.g.diagnostics_active = not vim.g.diagnostics_active
    if vim.g.diagnostics_active then
        vim.diagnostic.show()
    else
        vim.diagnostic.hide()
    end
end, { silent = true, desc = "Toggle whether diagnostics are shown" })

-- Install any server from M.servers that Mason does not have yet. Meant for headless
-- use from plugins.sh (mason-lspconfig skips ensure_installed when headless), so it
-- writes to stdout directly. Blocks until the installs finish; needs network.
function M.mason_install_missing()
    local registry = require("mason-registry")
    registry.refresh()
    local to_package = require("mason-lspconfig").get_mappings().lspconfig_to_package
    local missing = {}
    for _, server in ipairs(M.servers) do
        local pkg = to_package[server]
        if pkg == nil then
            io.stdout:write("Mason: no package known for " .. server .. "\n")
        elseif not registry.is_installed(pkg) then
            table.insert(missing, pkg)
        end
    end
    if #missing == 0 then
        io.stdout:write("Mason: all language servers already installed\n")
        return
    end
    io.stdout:write("Mason: installing " .. table.concat(missing, " ") .. "\n")
    -- Mason relays installer stderr (for example "go: downloading ...") as error
    -- messages, which makes vim.cmd raise even when the install succeeded, so the
    -- receipt check below is what decides success.
    local ok, err = pcall(vim.cmd.MasonInstall, { args = missing })
    if not ok then
        io.stdout:write("Mason: " .. tostring(err) .. "\n")
    end
    local still_missing = {}
    for _, pkg in ipairs(missing) do
        if not registry.is_installed(pkg) then
            table.insert(still_missing, pkg)
        end
    end
    if #still_missing > 0 then
        io.stdout:write("Mason: failed to install " .. table.concat(still_missing, " ") .. "\n")
        vim.cmd("cquit 1")
    end
    io.stdout:write("Mason: installed " .. table.concat(missing, " ") .. "\n")
end

return M
