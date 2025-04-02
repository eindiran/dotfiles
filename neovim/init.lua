-----------------------------------------------------------------
--  FILE: init.lua
--  AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
--  DESCRIPTION: Config file for NeoVim
--  CREATED: Sun 21 Jul 2024
--  LAST MODIFIED: Tue 01 Apr 2025
--  VERSION: 1.0.5
-----------------------------------------------------------------

-- In the far off happy world where the vimscript is replaced entirely,
-- we should source the vimplug code here specifically:
-- vim.cmd('source ~/.config/nvim/plugs.vim')

-- In the even more far off happy world where we move away (mostly) from
-- vimscript plugins, we should consider using some of the following:
-- Package manager: lazy (https://github.com/folke/lazy.nvim)
-- LSP: switch from ycm to built-in LSP + completion with coq (
-- https://github.com/ms-jpq/coq_nvim)
-- File explorer: chadtree (https://github.com/ms-jpq/chadtree)
-- or nvim-tree (https://github.com/nvim-tree/nvim-tree.lua)
-- LLM integration: codecompanion (https://github.com/olimorris/codecompanion.nvim)
-- or avante (https://github.com/yetone/avante.nvim)
-- Debugger: nvim-dap (https://github.com/mfussenegger/nvim-dap)

-- vim.opt.termguicolors = true

-- Source vimscript neovim config
vim.cmd("source ~/.config/nvim/neovim.vim")
-- Set the <Leader> key to \ (backslash)
vim.g.mapleader = "\\"
-- Get system OS info:
local uname_info = vim.loop.os_uname()

-----------------------------------------------------------------
--  Folding
-----------------------------------------------------------------
-- Fold by syntax rather than indent or manual
vim.opt.foldmethod = "syntax"
-- All folds open on file open; can be overriden
-- on some filetypes/plugins. Eg vim-markdown folds much more aggressively
vim.opt.foldlevelstart = 99
-- Toggle fold w/ spacebar
-- If cursor is on a folded line (>0), toggle the fold ('za').
-- Otherwise, execute the default action for <Space>
-- Equivalent to:
-- nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vim.keymap.set("n", " ", function()
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
vim.keymap.set("n", " -", "zx", {
    silent = true,
    noremap = true,
    desc = "Reset folds",
})

-- Totally unfold everything
-- Equivalent to:
-- nnoremap <silent> <Space>+ @=(foldlevel('.')?'zR':"\<Space>")<CR>
vim.keymap.set("n", " +", function()
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
vim.keymap.set("n", " =", "zM", {
    silent = true,
    remap = true,
    desc = "Refold all",
})
-- Create fold with spacebar
vim.keymap.set("v", " ", "zf", {
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
vim.keymap.set(
    "n",
    "q:",
    "<nop>",
    { silent = true, remap = false, desc = "Disable q: for Command-line window" }
)
vim.keymap.set(
    "n",
    "<Leader>q:",
    "q:",
    { silent = true, remap = false, desc = "Enable Command-line window" }
)

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
vim.keymap.set(
    "n",
    "<Leader><Tab>",
    "<Plug>(fzf-maps-n)",
    { silent = true, noremap = true, desc = "fzf Normal maps" }
)
vim.keymap.set(
    "x",
    "<Leader><Tab>",
    "<Plug>(fzf-maps-x)",
    { silent = true, noremap = true, desc = "fzf Visual maps" }
)
vim.keymap.set(
    "o",
    "<Leader><Tab>",
    "<Plug>(fzf-maps-o)",
    { silent = true, noremap = true, desc = "fzf Operator-pending maps" }
)
vim.keymap.set(
    "i",
    "<C-X><C-W>",
    "<Plug>(fzf-complete-word)",
    { silent = true, noremap = true, desc = "fzf Complete word" }
)
vim.keymap.set(
    "i",
    "<C-X><C-P>",
    "fzf#vim#complete#path('fd')",
    { silent = true, expr = true, noremap = true, desc = "fzf Complete path (fd)" }
)
vim.keymap.set(
    "i",
    "<C-X><C-F>",
    "fzf#vim#complete#path('fd -t f')",
    { silent = true, expr = true, noremap = true, desc = "fzf Complete file path (fd)" }
)
vim.keymap.set(
    "i",
    "<C-X><C-K>",
    "fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})",
    { silent = true, expr = true, noremap = true, desc = "fzf Complete word with popup window" }
)
vim.keymap.set(
    "i",
    "<C-X><C-L>",
    "<Plug>(fzf-complete-line)",
    { silent = true, noremap = true, desc = "fzf Complete line" }
)
vim.keymap.set(
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
vim.keymap.set(
    "n",
    "<F7>",
    __lualine_toggle,
    { silent = true, remap = false, desc = "Toggle lualine" }
)

-----------------------------------------------------------------
--  Vimspector setup
--  See: https://github.com/puremourning/vimspector
-----------------------------------------------------------------
-- Select "gadgets" to use in vimspector
vim.g.vimspector_install_gadgets = { "debugpy", "CodeLLDB" }

vim.keymap.set("n", "<Leader><F3>", "<Plug>VimspectorStop", { silent = true, remap = false })
vim.keymap.set("n", "<Leader><F4>", "<Plug>VimspectorRestart", { silent = true, remap = false })
vim.keymap.set("n", "<Leader><F5>", "<Plug>VimspectorContinue", { silent = true, remap = false })
vim.keymap.set("n", "<Leader><F6>", "<Plug>VimspectorPause", { silent = true, remap = false })
vim.keymap.set("n", "<Leader><F7>", "<Plug>VimspectorRunToCursor", { silent = true, remap = false })
vim.keymap.set(
    "n",
    "<Leader><F8>",
    "<Plug>VimspectorToggleConditionalBreakpoint",
    { silent = true, remap = false }
)
vim.keymap.set(
    "n",
    "<Leader><F9>",
    "<Plug>VimspectorToggleBreakpoint",
    { silent = true, remap = false }
)
vim.keymap.set("n", "<Leader><F10>", "<Plug>VimspectorStepOver", { silent = true, remap = false })
vim.keymap.set("n", "<Leader><F11>", "<Plug>VimspectorStepInto", { silent = true, remap = false })
vim.keymap.set("n", "<Leader><F12>", "<Plug>VimspectorStepOut", { silent = true, remap = false })
vim.keymap.set("n", "<Leader>di", "<Plug>VimspectorBalloonEval", { silent = true, remap = false })
vim.keymap.set("x", "<Leader>di", "<Plug>VimspectorBalloonEval", { silent = true, remap = false })
vim.keymap.set("n", "=<F11>", "<Plug>VimspectorUpFrame", { silent = true, remap = false })
vim.keymap.set("n", "=<F12>", "<Plug>VimspectorDownFrame", { silent = true, remap = false })
vim.keymap.set("n", "<Leader>b", "<Plug>VimspectorBreakpoints", { silent = true, remap = false })
vim.keymap.set("n", "<Leader><C-D>", "<Plug>VimspectorDisassemble", { silent = true, remap = false })

-----------------------------------------------------------------
--  neo-tree setup
--  See: https://github.com/nvim-neo-tree/neo-tree.nvim
-----------------------------------------------------------------
-- Key mapping for toggling Neotree full-screen: if opening, open in the
-- current directory and reveal the opened file if any.
vim.keymap.set(
    "n",
    "<F8>",
    ":Neotree toggle position=current reveal<CR>",
    { silent = true, remap = false, desc = "Toggle Neotree (fullscreen)" }
)
-- Key mapping for toggling Neotree sidebar: if opening, open in the current
-- directory and reveal the opened file if any.
vim.keymap.set(
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

-----------------------------------------------------------------
--  F-key mappings
--  Other than the F-key mappings defined above ^
-----------------------------------------------------------------
vim.keymap.set(
    "n",
    "<F1>",
    ":call ShowMappedFKeys()<CR>",
    { silent = true, remap = false, desc = "Show the list of mapped Function keys" }
)
vim.keymap.set(
    "n",
    "<F2>",
    ":map<CR>",
    { silent = true, remap = false, desc = "Show the entire list of mapped keys" }
)
vim.keymap.set(
    "n",
    "<F3>",
    ":call ToggleALE()<CR>",
    { silent = true, remap = false, desc = "Toggle ALE" }
)
vim.keymap.set(
    "n",
    "<F4>",
    ":%y+ <CR>",
    { silent = true, remap = false, desc = "Yank entire file into system clipboard" }
)
vim.keymap.set(
    "n",
    "<F5>",
    ":set ignorecase! ignorecase?<CR>:set smartcase! smartcase?<CR>",
    { silent = true, remap = false, desc = "Toggle case sensitivity" }
)
vim.keymap.set(
    "n",
    "<F6>",
    ":let _s=@/<Bar>:%s/s+$//e<Bar>:let @/=_s<Bar><CR>",
    { silent = true, remap = false, desc = "Strip trailing whitespace" }
)
