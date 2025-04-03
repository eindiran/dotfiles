-----------------------------------------------------------------
--  FILE: init.lua
--  AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
--  DESCRIPTION: Config file for NeoVim
--  CREATED: Sun 21 Jul 2024
--  LAST MODIFIED: Wed 02 Apr 2025
--  VERSION: 1.0.12
-----------------------------------------------------------------

-----------------------------------------------------------------
-- Notes:
-----------------------------------------------------------------
-- In the far off happy world where the vimscript is replaced entirely,
-- we should source the vimplug code here specifically:
-- vim.cmd('source ~/.config/nvim/plugs.vim')

-- In the even more far off happy world where we move away (mostly) from
-- vimscript plugins, we should consider using some of the following:
-- LSP: switch from ycm to built-in LSP + completion with coq (
-- https://github.com/ms-jpq/coq_nvim)
-- LLM integration: codecompanion (https://github.com/olimorris/codecompanion.nvim)
-- or avante (https://github.com/yetone/avante.nvim)
-- Debugger: nvim-dap (https://github.com/mfussenegger/nvim-dap)

-----------------------------------------------------------------
-- Initial setup
-----------------------------------------------------------------
-- Setup lazy.nvim (if required):
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
-- Set packpath to equal the modified runtimepath
-- Equivalent to: let &packpath = &runtimepath
vim.opt.packpath = vim.opt.runtimepath:get()
-- Set the <Leader> key to \ (backslash)
vim.g.mapleader = "\\"
-- Get system OS info:
local uname_info = vim.loop.os_uname()
-- Make it so we don't need to type 'vim.keymap.set' every time we
-- want to map keys
local map = vim.keymap.set

-----------------------------------------------------------------
-- lazy.nvim plugin specification
-----------------------------------------------------------------
require("lazy").setup({
    {
        -- Tresitter interaction
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "cmake",
                    "cpp",
                    "dockerfile",
                    "html",
                    "javascript",
                    "json",
                    "latex",
                    "llvm",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "query",
                    "rst",
                    "rust",
                    "sql",
                    "toml",
                    "typescript",
                    "typst",
                    "vim",
                    "vimdoc",
                    "vue",
                    "xml",
                    "yaml",
                    "zig",
                },
                sync_install = false,
                -- highlight = { enable = true },
                -- indent = { enable = true },
            })
        end,
    },
    {
        -- Completion
        "ycm-core/YouCompleteMe",
        build = function(plugin)
            print("Running post-install for " .. plugin.name)
            local build_cmd = { "./install.py", "--all" }
            local opts = {
                cwd = plugin.dir,
                text = true,
                stdout = vim.NIL,
                stderr = vim.NIL,
            }
            local result = vim.system(build_cmd, opts):wait()
            if result.code == 0 then
                vim.notify(plugin.name .. " built successfully!", vim.log.levels.INFO)
                print(result.stdout)
                return true
            else
                vim.notify(
                    "Build failed for " .. plugin.name .. "(" .. result.code .. ")",
                    vim.log.levels.ERROR
                )
                print(result.stdout)
                print(result.stderr)
                return false
            end
        end,
    },
    {
        --  File browser
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
            "3rd/image.nvim",
        },
        lazy = false,
    },
    {
        --    Status line for nvim
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },
    {
        --    Gruvbox colorscheme
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
    },
    {
        --    Markdown support
        "OXY2DEV/markview.nvim",
        lazy = false,
        build = ":TSInstall markdown markdown_inline html latex typst yaml",

        -- For blink.cmp's completion
        -- source
        dependencies = {
            "saghen/blink.cmp",
            "nvim-treesitter/nvim-treesitter",
        },

        config = {
            preview = {
                icon_provider = "devicons",
            },
        },
    },
    -----------------------------------------------------------------
    -- General plugins:
    -----------------------------------------------------------------
    "echasnovski/mini.nvim", --        Powerful plugin with many features
    "dense-analysis/ale", --           Multi lang linting manager
    "tpope/vim-fugitive", --           Integration w/ git
    "tpope/vim-abolish", --            Smart handling of advanced regexes
    "junegunn/fzf.vim", --             FZF bindings and delta bindings
    "linrongbin16/gentags.nvim", --    Tag file generator
    "puremourning/vimspector", --      Debugger
    "eindiran/utils.vim", --           General utilities
    -----------------------------------------------------------------
    -- Filetype specific plugins:
    -----------------------------------------------------------------
    "eindiran/awk-support", --         awk support
    "eindiran/c-support", --           C/C++ support
    "eindiran/bash-support.vim", --    Shell scripting integration
})
map("n", "<F10>", ":Lazy<CR>", { silent = true, remap = false, desc = "Open Lazy" })

-----------------------------------------------------------------
-- Source vimscript neovim config.
-- This is done to gradually bootstrap into using Lua for the entire
-- config.
-----------------------------------------------------------------
vim.cmd("source " .. vim.fn.expand("~/.config/nvim/neovim.vim"))

-----------------------------------------------------------------
--  Color scheme
-----------------------------------------------------------------
vim.opt.background = "dark"
vim.opt.termguicolors = true
require("gruvbox").setup({
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = "", -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
})
vim.cmd("colorscheme gruvbox")

-----------------------------------------------------------------
-- Spaces, Tabs, and indenting behavior:
-----------------------------------------------------------------
vim.o.tabstop = 4 -- 4 space per tab press
vim.o.expandtab = true -- Use spaces for tabs
vim.o.softtabstop = 4 -- 4 space per tab press
vim.o.shiftwidth = 4 -- 4 spaces per shift (>)
vim.o.shiftround = true -- Round indentation to a multiple of shiftwidth
vim.o.virtualedit = "all" -- Allow movement/insert past the final char in a line
vim.o.copyindent = true -- Use the whitespace characters of the previous line

-----------------------------------------------------------------
-- UI
-----------------------------------------------------------------
vim.o.number = true -- Show line numbers
vim.o.visualbell = true -- Don't beep
vim.o.errorbells = false -- Don't beep
-- The below two lines show which whitespace is tabs vs spaces
vim.o.list = true
vim.o.listchars = "tab:▸·,trail:·,nbsp:·"
-- Make vim use the system clipboard:
-- macOS - see here: https://stackoverflow.com/questions/17561706/
-- Linux - see here: https://vim.wikia.com/wiki/VimTip21
vim.opt.clipboard:prepend("unnamed,unnamedplus")

-----------------------------------------------------------------
-- utils.vim
-----------------------------------------------------------------
vim.g.utilsvim_gitconflict_exact = 1
vim.g.utilsvim_autoversion = 0
vim.g.utilsvim_autotimestamp = 1

-----------------------------------------------------------------
-- Case sensitivity:
-----------------------------------------------------------------
vim.o.ignorecase = true -- Ignore case when searching
vim.o.smartcase = true -- Case-insensitive if all chars are lowercase

-----------------------------------------------------------------
-- Dynamically set wildignore from .gitignore
-----------------------------------------------------------------
-- Try to use local gitignore, or global one if we can't find or can't
-- load the local one.
local local_gitignore = ".gitignore"
local global_gitignore = vim.fn.expand("~/.gitignore")
local gitignore_file = (vim.fn.filereadable(local_gitignore) == 1) and local_gitignore
    or global_gitignore
if vim.fn.filereadable(gitignore_file) == 1 then
    local lines = vim.fn.readfile(gitignore_file)
    local ignore_patterns = {}
    for _, line in ipairs(lines) do
        local processed_line = vim.trim(line)
        if
            processed_line:match("^%s*$") -- Whitespace-only line (Lua %s matches whitespace)
            or processed_line:match("^%s*#") -- Comment line
            or processed_line:match("^!") -- Negation line
            or processed_line:match("^<<+") -- Git conflict marker
            or processed_line:match("^>>+") -- Git conflict marker
            or processed_line:match("^==+")
        then -- Git conflict marker
        -- If any condition matches, skip to the next line (implicit continue)
        else
            -- Continuation lines:
            -- Check if line ends with '/' (directory pattern)
            if processed_line:match("/$") then
                -- Append the pattern followed by '*' to match directory contents
                table.insert(ignore_patterns, processed_line .. "*")
            else
                -- Otherwise, add the pattern as is
                table.insert(ignore_patterns, processed_line)
            end
        end
    end
    if #ignore_patterns > 0 then
        table.sort(ignore_patterns)
        local unique_patterns = {}
        if #ignore_patterns > 0 then
            unique_patterns[1] = ignore_patterns[1]
            local j = 1
            for i = 2, #ignore_patterns do
                if ignore_patterns[i] ~= ignore_patterns[i - 1] then
                    j = j + 1
                    unique_patterns[j] = ignore_patterns[i]
                end
            end
        end
        -- Join the unique, sorted patterns into a single comma-separated string
        local ignore_string = table.concat(unique_patterns, ",")
        -- Append the resulting string to Neovim's 'wildignore' option
        if ignore_string ~= "" then
            vim.opt.wildignore:append(ignore_string)
        end
    end
end

-----------------------------------------------------------------
-- Yanking
-----------------------------------------------------------------
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.hl.on_yank()
    end,
    desc = "Briefly highlight yanked text",
})

-----------------------------------------------------------------
-- Paragraph formatting
-----------------------------------------------------------------
-- Use Q for formatting the current paragraph (or selection)
map("v", "Q", "gq", { remap = true })
map("n", "Q", "gqap", { remap = true })

-----------------------------------------------------------------
-- Window controls
-----------------------------------------------------------------
-- Let j and k behave more naturally on wrapped lines
map("o", "j", "gj", { silent = true })
map("o", "k", "gk", { silent = true })
-- Easy window navigation
map({ "n", "v", "o" }, "<C-H>", "<C-W>h", { remap = true })
map({ "n", "v", "o" }, "<C-J>", "<C-W>j", { remap = true })
map({ "n", "v", "o" }, "<C-K>", "<C-W>k", { remap = true })
map({ "n", "v", "o" }, "<C-L>", "<C-W>l", { remap = true })

-----------------------------------------------------------------
-- Buffer controls
-----------------------------------------------------------------
-- Cycle through the buffers with \\ (forward) and \| or \<Space> (backwards)
map("n", "<Leader><Leader>", ":bn<CR>", { silent = true, remap = false })
map("n", "<Leader>|", ":bp<CR>", { silent = true, remap = false })
map("n", "<Leader> ", ":bp<CR>", { silent = true, remap = false })
-- Hop to the alternate file buffer with -
map("n", "-", "<C-^>", { silent = true, remap = false })
-- Set the conceallevel manually in normal mode
map("n", "=cl", ":set conceallevel=2<CR>", { silent = true, remap = false })
map("n", "-cl", ":set conceallevel=0<CR>", { silent = true, remap = false })
-- Undo last search highlighting by pressing enter again
map("n", "<CR>", ":noh<CR><CR>", { silent = true, remap = false })
-- Delete messages buffer
map("n", "<C-C>", ":messages clear<CR>", { silent = true, remap = false })
-- Allow writes to files owned by root using `w!!`
vim.cmd([[cabbrev w!! execute 'silent! write !sudo tee % >/dev/null' <Bar> edit!]])
-- Sort words in a line in normal mode:
map("n", "=sw", function()
    local line_num = vim.api.nvim_win_get_cursor(0)[1]
    local line_content = vim.api.nvim_buf_get_lines(0, line_num - 1, line_num, false)[1]
    if line_content == nil or line_content == "" then
        return
    end
    -- Split by one or more spaces to handle varying spacing
    local words = vim.split(line_content, "%s+")
    table.sort(words)
    local sorted_line = table.concat(words, " ")
    vim.api.nvim_buf_set_lines(0, line_num - 1, line_num, false, { sorted_line })
end, { silent = true, remap = false })
map("n", "=sa", ":%!sort<CR>", { silent = true, remap = false })
map("n", "=sn", ":%!sort -n<CR>", { silent = true, remap = false })

-----------------------------------------------------------------
-- Set behaviors on buffer load for specific filetypes:
-----------------------------------------------------------------
-- Create an autocommand group to organize these settings
local filetype_settings_group = vim.api.nvim_create_augroup("FileTypeSettings", { clear = true })
-- *.yaml,*.yml --> YAML
-- Set filetype and foldmethod when opening yaml files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_settings_group,
    pattern = { "*.yaml", "*.yml" },
    command = "set filetype=yaml foldmethod=indent",
})
-- Set buffer-local options specifically for yaml filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = filetype_settings_group,
    pattern = "yaml",
    command = "setlocal ts=2 sts=2 sw=2 expandtab",
})
-- *.rst --> reStructuredText
-- Set filetype and foldmethod when opening rst files
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_settings_group,
    pattern = "*.rst",
    command = "set filetype=rst foldmethod=indent",
})
-- Set the conceallevel to hide by default
-- Set window-local conceallevel for markdown filetypes
vim.api.nvim_create_autocmd("FileType", {
    group = filetype_settings_group,
    pattern = "markdown",
    callback = function()
        -- 'conceallevel' is window-local, so we set it via vim.wo
        vim.wo.conceallevel = 2
    end,
})

-----------------------------------------------------------------
--  Folding
-----------------------------------------------------------------
-- Fold by syntax rather than indent or manual
vim.opt.foldmethod = "syntax"
-- All folds open on file open; can be overriden
-- on some filetypes/plugins.
vim.opt.foldlevelstart = 99
-- Toggle fold w/ spacebar
-- If cursor is on a folded line (>0), toggle the fold ('za').
-- Otherwise, execute the default action for <Space>
-- Equivalent to:
-- nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
map("n", " ", function()
    if vim.fn.foldlevel(".") > 0 then
        return "za"
    else
        return "<Space>"
    end
end, {
    silent = true,
    expr = true,
    desc = "Toggle fold",
})

-- Reset folds
-- Equivalent to zx
map("n", " -", "zx", {
    silent = true,
    noremap = true,
    desc = "Reset folds",
})

-- Totally unfold everything
-- Equivalent to:
-- nnoremap <silent> <Space>+ @=(foldlevel('.')?'zR':"\<Space>")<CR>
map("n", " +", function()
    if vim.fn.foldlevel(".") > 0 then
        return "zR" -- Unfold all levels
    else
        return "<Space>"
    end
end, {
    silent = true,
    expr = true,
    desc = "Unfold all / Space",
})

-- Totally refold everything
map("n", " =", "zM", {
    silent = true,
    remap = true,
    desc = "Refold all",
})
-- Create fold with spacebar
map("v", " ", "zf", {
    silent = true,
    noremap = true,
    desc = "Create fold in visual mode",
})

-----------------------------------------------------------------
--  Command window setup
-----------------------------------------------------------------
local reopenCmdWinGrp = vim.api.nvim_create_augroup("ReopenCmdWinAfterExec", { clear = true })
vim.api.nvim_create_autocmd("CmdwinEnter", {
    pattern = "*",
    group = reopenCmdWinGrp,
    desc = "Remap <CR> in CmdWin to execute and reopen; <Leader><CR> for default",
    command = 'nnoremap <buffer> <silent> <CR> :execute getline(".") <Bar> redraw! <Bar> q:<CR> | nnoremap <buffer> <silent> <Leader><CR> <CR>',
})
-- Delete default key-mapping for command window since is annoying
-- and I constantly press it on accident when quiting
map(
    "n",
    "q:",
    "<nop>",
    { silent = true, remap = false, desc = "Disable q: for Command-line window" }
)
map("n", "<Leader>q:", "q:", { silent = true, remap = false, desc = "Enable Command-line window" })

-----------------------------------------------------------------
--  fzf.vim setup
--  See: https://github.com/junegunn/fzf.vim
-----------------------------------------------------------------
if uname_info and uname_info.sysname == "Darwin" then
    -- On macOS, add the Homebrew fzf path to the runtimepath
    vim.opt.runtimepath:append(vim.trim(vim.fn.system("brew --prefix fzf")))
else
    -- On other systems, add the fzf path assumed to be in the home directory
    vim.opt.runtimepath:append(vim.fn.expand("~/.fzf"))
end
-- Base config dict:
vim.g.fzf_vim = {}
vim.g.fzf_vim.preview_window = { "hidden,right,50%,<70(up,40%)", "ctrl-/" }
vim.g.fzf_vim.commits_log_options = "--graph --color=always"
-- Use ctags:
vim.g.fzf_vim.tags_command = "ctags -R"
-- Set the default listproc to quickfix
vim.g.fzf_vim.listproc = function(list)
    return vim.fn["fzf#vim#listproc#quickfix"](list)
end
-- Set the ripgrep listproc to location
vim.g.fzf_vim.listproc_rg = function(list)
    return vim.fn["fzf#vim#listproc#location"](list)
end
map(
    "n",
    "<Leader><Tab>",
    "<Plug>(fzf-maps-n)",
    { silent = true, noremap = true, desc = "fzf Normal maps" }
)
map(
    "x",
    "<Leader><Tab>",
    "<Plug>(fzf-maps-x)",
    { silent = true, noremap = true, desc = "fzf Visual maps" }
)
map(
    "o",
    "<Leader><Tab>",
    "<Plug>(fzf-maps-o)",
    { silent = true, noremap = true, desc = "fzf Operator-pending maps" }
)
map(
    "i",
    "<C-X><C-W>",
    "<Plug>(fzf-complete-word)",
    { silent = true, noremap = true, desc = "fzf Complete word" }
)
map(
    "i",
    "<C-X><C-P>",
    "fzf#vim#complete#path('fd')",
    { silent = true, expr = true, noremap = true, desc = "fzf Complete path (fd)" }
)
map(
    "i",
    "<C-X><C-F>",
    "fzf#vim#complete#path('fd -t f')",
    { silent = true, expr = true, noremap = true, desc = "fzf Complete file path (fd)" }
)
map(
    "i",
    "<C-X><C-K>",
    "fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})",
    { silent = true, expr = true, noremap = true, desc = "fzf Complete word with popup window" }
)
map(
    "i",
    "<C-X><C-L>",
    "<Plug>(fzf-complete-line)",
    { silent = true, noremap = true, desc = "fzf Complete line" }
)
map(
    "i",
    "<C-X><C-B>",
    "<Plug>(fzf-complete-buffer-line)",
    { silent = true, noremap = true, desc = "fzf Complete buffer line" }
)

-----------------------------------------------------------------
--  lualine.nvim setup
--  See: https://github.com/nvim-lualine/lualine.nvim
-----------------------------------------------------------------
require("lualine").setup({
    options = {
        icons_enabled = true,
        theme = "powerline",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
            statusline = 100,
            tabline = 100,
            winbar = 100,
        },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = {
            "branch",
            "diff",
            {
                "diagnostics",
                -- Table of diagnostic sources, available sources are:
                --   'nvim_lsp', 'nvim_diagnostic', 'nvim_workspace_diagnostic', 'coc', 'ale', 'vim_lsp'.
                -- or a function that returns a table as such:
                --   { error=error_cnt, warn=warn_cnt, info=info_cnt, hint=hint_cnt }
                sources = { "nvim_diagnostic", "ale" },

                -- Displays diagnostics for the defined severity types
                sections = { "error", "warn", "info", "hint" },

                diagnostics_color = {
                    -- Same values as the general color option can be used here.
                    error = "DiagnosticError", -- Changes diagnostics' error color.
                    warn = "DiagnosticWarn", -- Changes diagnostics' warn color.
                    info = "DiagnosticInfo", -- Changes diagnostics' info color.
                    hint = "DiagnosticHint", -- Changes diagnostics' hint color.
                },
                symbols = { error = "E", warn = "W", info = "I", hint = "H" },
                colored = true, -- Displays diagnostics status in color if set to true.
                update_in_insert = false, -- Update diagnostics in insert mode.
                always_visible = false, -- Show diagnostics even if there are none.
            },
        },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { "fugitive", "fzf", "neo-tree", "quickfix" },
})

-- Function to manage toggling Lualine
local __lualine_unhidden = true
local function __lualine_toggle()
    __lualine_unhidden = not __lualine_unhidden
    require("lualine").hide({
        unhide = __lualine_unhidden,
    })
end
map("n", "<F7>", __lualine_toggle, { silent = true, remap = false, desc = "Toggle lualine" })

-----------------------------------------------------------------
--  gentags setup
--  See: https://github.com/linrongbin16/gentags.nvim
-----------------------------------------------------------------
require("gentags").setup()

-----------------------------------------------------------------
--  Vimspector setup
--  See: https://github.com/puremourning/vimspector
-----------------------------------------------------------------
-- Select "gadgets" to use in vimspector
vim.g.vimspector_install_gadgets = { "debugpy", "CodeLLDB" }

map("n", "<Leader><F3>", "<Plug>VimspectorStop", { silent = true, remap = false })
map("n", "<Leader><F4>", "<Plug>VimspectorRestart", { silent = true, remap = false })
map("n", "<Leader><F5>", "<Plug>VimspectorContinue", { silent = true, remap = false })
map("n", "<Leader><F6>", "<Plug>VimspectorPause", { silent = true, remap = false })
map("n", "<Leader><F7>", "<Plug>VimspectorRunToCursor", { silent = true, remap = false })
map(
    "n",
    "<Leader><F8>",
    "<Plug>VimspectorToggleConditionalBreakpoint",
    { silent = true, remap = false }
)
map("n", "<Leader><F9>", "<Plug>VimspectorToggleBreakpoint", { silent = true, remap = false })
map("n", "<Leader><F10>", "<Plug>VimspectorStepOver", { silent = true, remap = false })
map("n", "<Leader><F11>", "<Plug>VimspectorStepInto", { silent = true, remap = false })
map("n", "<Leader><F12>", "<Plug>VimspectorStepOut", { silent = true, remap = false })
map("n", "<Leader>di", "<Plug>VimspectorBalloonEval", { silent = true, remap = false })
map("x", "<Leader>di", "<Plug>VimspectorBalloonEval", { silent = true, remap = false })
map("n", "=<F11>", "<Plug>VimspectorUpFrame", { silent = true, remap = false })
map("n", "=<F12>", "<Plug>VimspectorDownFrame", { silent = true, remap = false })
map("n", "<Leader>b", "<Plug>VimspectorBreakpoints", { silent = true, remap = false })
map("n", "<Leader><C-D>", "<Plug>VimspectorDisassemble", { silent = true, remap = false })

-----------------------------------------------------------------
--  neo-tree setup
--  See: https://github.com/nvim-neo-tree/neo-tree.nvim
-----------------------------------------------------------------
-- Key mapping for toggling Neotree full-screen: if opening, open in the
-- current directory and reveal the opened file if any.
map(
    "n",
    "<F8>",
    ":Neotree toggle position=current reveal<CR>",
    { silent = true, remap = false, desc = "Toggle Neotree (fullscreen)" }
)
-- Key mapping for toggling Neotree sidebar: if opening, open in the current
-- directory and reveal the opened file if any.
map(
    "n",
    "<F9>",
    ":Neotree toggle reveal<CR>",
    { silent = true, remap = false, desc = "Toggle Neotree (left-bar)" }
)

local inputs = require("neo-tree.ui.inputs")

-- Trash the target
local function trash(state)
    local node = state.tree:get_node()
    if node.type == "message" then
        return
    end
    local _, name = require("neo-tree.utils").split_path(node.path)
    local msg = string.format("Are you sure you want to trash '%s'?", name)
    inputs.confirm(msg, function(confirmed)
        if not confirmed then
            return
        end
        vim.api.nvim_command("silent !trash -F " .. node.path)
        require("neo-tree.sources.manager").refresh(state)
    end)
end

-- Trash the selections (visual mode)
local function trash_visual(state, selected_nodes)
    local paths_to_trash = {}
    for _, node in ipairs(selected_nodes) do
        if node.type ~= "message" then
            table.insert(paths_to_trash, node.path)
        end
    end
    local msg = "Are you sure you want to trash " .. #paths_to_trash .. " items?"
    inputs.confirm(msg, function(confirmed)
        if not confirmed then
            return
        end
        for _, path in ipairs(paths_to_trash) do
            vim.api.nvim_command("silent !trash -F " .. path)
        end
        require("neo-tree.sources.manager").refresh(state)
    end)
end

require("neo-tree").setup({
    window = {
        mappings = {
            ["T"] = "trash",
        },
        position = "left",
    },
    commands = {
        trash = trash,
        trash_visual = trash_visual,
    },
})

-----------------------------------------------------------------
--  Key mappings
--  Other than the key mappings defined above ^
--  And the F-key mappings defined below
-----------------------------------------------------------------
map(
    "n",
    "=vp",
    "<Plug>(UpdatePatchVersion)",
    { silent = true, remap = false, desc = "Update the patch version number" }
)
map(
    "n",
    "=vi",
    "<Plug>(UpdateMinorVersion)",
    { silent = true, remap = false, desc = "Update the minor version number" }
)
map(
    "n",
    "=vm",
    "<Plug>(UpdateMajorVersion)",
    { silent = true, remap = false, desc = "Update the major version number" }
)
map(
    "n",
    "=t",
    "<Plug>(UpdateTimestamp)",
    { silent = true, remap = false, desc = "Update the timestamp for last modification" }
)
map(
    "n",
    "=n",
    "<Plug>(ToggleRelativeNumber)",
    { silent = true, remap = false, desc = "Toggle relative line numbers" }
)
map("n", "=fh", "<Plug>(FormatHex)", { silent = true, remap = false, desc = "Format hex file" })
map(
    "n",
    "=fb",
    "<Plug>(FormatBinary)",
    { silent = true, remap = false, desc = "Format binary file" }
)
map("n", "=fj", "<Plug>(FormatJSON)", { silent = true, remap = false, desc = "Format JSON file" })
map("n", "=fx", "<Plug>(FormatXML)", { silent = true, remap = false, desc = "Format XML file" })
map(
    "n",
    "=c",
    "<Plug>(SearchGitConflictMarkers)",
    { silent = true, remap = false, desc = "Automatically search for conflict markers" }
)
map(
    "n",
    "=d",
    "<Plug>(DeleteGitConflictSection)",
    { silent = true, remap = false, desc = "Delete git conflict section currently under the cursor" }
)

-----------------------------------------------------------------
--  F-key mappings
--  Other than the F-key mappings defined above ^
-----------------------------------------------------------------
map(
    "n",
    "<F1>",
    "<Plug>(ShowMappedFKeys)",
    { silent = true, remap = false, desc = "Show the list of mapped Function keys" }
)
map(
    "n",
    "<F2>",
    ":map<CR>",
    { silent = true, remap = false, desc = "Show the entire list of mapped keys" }
)
map("n", "<F3>", ":call ToggleALE()<CR>", { silent = true, remap = false, desc = "Toggle ALE" })
map(
    "n",
    "<F4>",
    ":%y+ <CR>",
    { silent = true, remap = false, desc = "Yank entire file into system clipboard" }
)
map(
    "n",
    "<F5>",
    ":set ignorecase! ignorecase?<CR>:set smartcase! smartcase?<CR>",
    { silent = true, remap = false, desc = "Toggle case sensitivity" }
)
map(
    "n",
    "<F6>",
    ":let _s=@/<Bar>:%s/s+$//e<Bar>:let @/=_s<Bar><CR>",
    { silent = true, remap = false, desc = "Strip trailing whitespace" }
)
