"'---------------------------------------------------------------------
" FILE: neovim.vim
" AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
" DESCRIPTION: Config file for NeoVim (in vimscript). Slowly being
" being replaced by init.lua which is in NeoVim's native Lua
" CREATED: Sun 21 Jul 2024
" LAST MODIFIED: Wed 02 Apr 2025
" VERSION: 2.0.0
"---------------------------------------------------------------------

"---------------------------------------------------------------------
" Setup fugitive:
"---------------------------------------------------------------------
nnoremap <Leader>gd :Gvdiff<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
"---------------------------------------------------------------------
" Setup ALE:
"---------------------------------------------------------------------
let g:ale_disable_lsp = 1
let g:ale_use_neovim_diagnostics_api = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {
    \'c': ['clangd', 'clangcheck', 'clangtidy'],
    \'go': ['golangci_lint'],
    \'javascript': ['eslint'],
    \'lua': ['luacheck'],
    \'make': ['checkmake'],
    \'markdown': ['vale'],
    \'python': ['ruff', 'mypy'],
    \'sh': ['shellcheck'],
    \'vue': ['eslint', 'stylelint', 'vls'],
\}
" Alias Vue to support linting/fixing/highlighting with all the
" relevant filetypes.
let g:ale_linter_aliases = {'vue': ['vue', 'css', 'javascript', 'html']}
" Don't enable fixers for all languages, as some plugins for languages
" already enable them (e.g. vim-go for Go)
let g:ale_fixers = {
    \'c': ['clangformat', 'clangtidy'],
    \'javascript': ['eslint', 'prettier'],
    \'lua': ['stylua'],
    \'markdown': ['prettier'],
    \'python': ['ruff', 'ruff_format'],
    \'sh': ['shfmt'],
    \'vue': ['eslint', 'prettier'],
    \'yaml': ['prettier'],
    \'*': ['remove_trailing_lines', 'trim_whitespace'],
\}
let g:ale_sh_shfmt_options = '-i=4 -ln=bash -ci -kp'
nmap <silent> =aj :ALENext<CR>
nmap <silent> <Leader>j :ALENext<CR>
nmap <silent> =ak :ALEPrevious<CR>
nmap <silent> <Leader>k :ALEPrevious<CR>
nmap <silent> =ad :ALEGoToDefinition<CR>
nmap <silent> <Leader>h :ALEHover<CR>
nmap <silent> =ai :ALEInfo<CR>
" Function to disable all ALE fixing and linting
function! DisableALE()
    let g:ale_lint_on_text_changed = 'never'
    let g:ale_lint_on_insert_leave = 0
    let g:ale_lint_on_save = 0
    let g:ale_fix_on_save = 0
    let g:ale_lint_on_enter = 0
endfunction
" Function to re-enable ALE
function! EnableALE()
    let g:ale_lint_on_text_changed = 0
    let g:ale_lint_on_insert_leave = 1
    let g:ale_lint_on_save = 1
    let g:ale_fix_on_save = 1
    let g:ale_lint_on_enter = 1
endfunction
" Function to toggle ALE
function! ToggleALE()
    if (g:ale_fix_on_save == 1)
        call DisableALE()
    else
        call EnableALE()
    endif
endfunction
