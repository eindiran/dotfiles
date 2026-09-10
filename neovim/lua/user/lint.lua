--[[
FILE: lua/user/lint.lua
DESCRIPTION: nvim-lint for linters that have no language server: checkmake for
Makefiles, hadolint for Dockerfiles. Runs on read, write, and leaving insert mode.
=at turns these linters and every diagnostic (LSP ones included) off and on; <F12> in
lsp.lua only hides them.
--]]
local M = {}
local lint = require("lint")

lint.linters_by_ft = {
    make = { "checkmake" },
    dockerfile = { "hadolint" },
}

M.enabled = true

-- Linters whose executable was already reported missing this session
local warned = {}

-- Linters for the buffer's filetype whose executable is on PATH. nvim-lint raises an
-- error for a missing binary, which would fire on every read of a Dockerfile on a
-- machine without hadolint, so those are skipped with one warning per session.
local function available_linters(buf)
    local ft = vim.bo[buf].filetype
    local ready = {}
    for _, name in ipairs(lint.linters_by_ft[ft] or {}) do
        local cmd = lint.linters[name].cmd
        if type(cmd) == "function" then
            cmd = cmd()
        end
        if vim.fn.executable(cmd) == 1 then
            table.insert(ready, name)
        elseif not warned[name] then
            warned[name] = true
            vim.notify(
                string.format("nvim-lint: %s not on PATH, %s files are not linted", cmd, ft),
                vim.log.levels.WARN
            )
        end
    end
    return ready
end

local function run_lint(buf)
    local names = available_linters(buf)
    if #names > 0 then
        lint.try_lint(names)
    end
end

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
    group = vim.api.nvim_create_augroup("UserLint", { clear = true }),
    callback = function(args)
        if M.enabled then
            run_lint(args.buf)
        end
    end,
})

function M.toggle()
    M.enabled = not M.enabled
    vim.diagnostic.enable(M.enabled)
    if M.enabled then
        run_lint(vim.api.nvim_get_current_buf())
    end
    vim.notify("Linting and diagnostics " .. (M.enabled and "enabled" or "disabled"))
end

vim.keymap.set("n", "=at", M.toggle, { silent = true, desc = "Toggle linting and diagnostics" })

return M
