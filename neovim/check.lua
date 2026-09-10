--[[
FILE: check.lua
DESCRIPTION: Body of check.sh. Run headless with _G.CHECK_DIR set to the fixture
directory. For each fixture it opens the file, waits for the expected language servers
to attach, and checks conform's formatter list or nvim-lint's linter list. Prints one
line per check and exits 1 if anything failed.
--]]
local dir = _G.CHECK_DIR
local failed = false

local function say(msg)
    io.stdout:write(msg, "\n")
end

local function check(ok, msg)
    if ok then
        say("ok:   " .. msg)
    else
        failed = true
        say("FAIL: " .. msg)
    end
end

-- Per fixture: servers that must attach, then either the conform formatter names or
-- lsp_format (conform defers to the server), and any nvim-lint linters.
local fixtures = {
    { file = "a.sh", servers = { "bashls" }, formatters = { "shfmt" } },
    { file = "crate/src/main.rs", servers = { "rust_analyzer" }, lsp_format = true },
    { file = "a.c", servers = { "clangd" }, lsp_format = true },
    {
        file = "a.py",
        servers = { "ruff", "ty" },
        formatters = { "ruff_organize_imports", "ruff_format" },
    },
    { file = "a.lua", servers = { "lua_ls" }, formatters = { "stylua" } },
    { file = "a.zig", servers = { "zls" }, formatters = { "zigfmt" } },
    { file = "mod/main.go", servers = { "gopls", "golangci_lint_ls" }, lsp_format = true },
    { file = "Dockerfile", servers = { "dockerls" }, linters = { "hadolint" } },
    { file = "Makefile", servers = {}, linters = { "checkmake" } },
}

-- Tools the servers, formatters, and linters above call from PATH
local tools = {
    "shellcheck",
    "hadolint",
    "checkmake",
    "stylua",
    "shfmt",
    "golangci-lint",
    "cargo",
    "go",
    "node",
    "python3",
}

local function attached(buf, name)
    return #vim.lsp.get_clients({ bufnr = buf, name = name }) > 0
end

local function all_attached(buf, names)
    for _, name in ipairs(names) do
        if not attached(buf, name) then
            return false
        end
    end
    return true
end

local function check_fixture(fx)
    vim.cmd.edit(dir .. "/" .. fx.file)
    local buf = vim.api.nvim_get_current_buf()
    local ft = vim.bo[buf].filetype
    say("--- " .. fx.file .. " (filetype " .. ft .. ")")
    -- Servers attach asynchronously; first starts of rust-analyzer and gopls are slow
    vim.wait(30000, function()
        return all_attached(buf, fx.servers)
    end, 100)
    for _, name in ipairs(fx.servers) do
        check(attached(buf, name), name .. " attached")
    end
    if fx.formatters or fx.lsp_format then
        local list, lsp = require("conform").list_formatters_to_run(buf)
        if fx.formatters then
            local names = vim.tbl_map(function(f)
                return f.name
            end, list)
            check(
                vim.deep_equal(names, fx.formatters),
                "conform formatters " .. table.concat(fx.formatters, ",")
            )
            for _, f in ipairs(list) do
                check(f.available, "formatter " .. f.name .. " available")
            end
        else
            check(lsp, "conform uses LSP formatting")
        end
    end
    if fx.linters then
        local configured = require("lint").linters_by_ft[ft] or {}
        check(
            vim.deep_equal(configured, fx.linters),
            "nvim-lint linters " .. table.concat(fx.linters, ",")
        )
    end
end

local function run()
    for _, fx in ipairs(fixtures) do
        -- One broken fixture must not hide the results of the others
        local ok, err = pcall(check_fixture, fx)
        if not ok then
            check(false, fx.file .. ": " .. tostring(err))
        end
    end
    say("--- PATH tools")
    for _, tool in ipairs(tools) do
        check(vim.fn.executable(tool) == 1, tool .. " on PATH")
    end
end

local ok, err = pcall(run)
if not ok then
    failed = true
    say("FAIL: " .. tostring(err))
end
say(failed and "RESULT: FAIL" or "RESULT: OK")
vim.cmd(failed and "cquit 1" or "qall!")
