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
"---------------------------------------------------------------------
" YouCompleteMe Configuration
"---------------------------------------------------------------------
if trim(system('uname -s')) ==? 'Darwin'
    " On macOS, make sure we set up some fiddly bits for YCM
    let g:ycm_clangd_binary_path = trim(system('brew --prefix llvm')).'/bin/clangd'

    " Below doesn't seem necessary anymore, but leaving it here for a while just
    " in case I need to remember how to do it
    " let g:ycm_server_python_interpreter = trim(system('brew --prefix python3')).'/bin/python3'
endif
let g:ycm_filetype_whitelist={'*': 1}
let g:ycm_filetype_blacklist={
    \'notes':1,
    \'unite':1,
    \'tagbar':1,
    \'pandoc':1,
    \'qf':1,
    \'infolog':1,
    \'mail':1,
    \'org':1
    \}
let g:ycm_language_server =
    \[
    \   {
    \    'name': 'zls',
    \    'filetypes': [ 'zig' ],
    \    'cmdline': [ '/usr/local/bin/zls' ]
    \   }
    \]
"---------------------------------------------------------------------
" vim-go
"---------------------------------------------------------------------
" These settings were taken from this blogpost:
" https://jogendra.dev/using-vim-for-go-development
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_fmt_autosave = 1
let g:go_fmt_command = "goimports"
let g:go_auto_type_info = 1
" Function to build .go files
function! BuildGoFiles()
    let l:file = expand('%')
    if l:file =~# '^\f\+_test\.go$'
        call go#test#Test(0, 1)
    elseif l:file =~# '^\f\+\.go$'
        call go#cmd#Build(0)
    endif
endfunction
" Map keys for most used commands.
" EX: `\b` for building, `\r` for running, `\t` for running tests,
" `\i` for running 'go install' and `\d` for getting docs.
autocmd FileType go nmap <silent> <Leader>b :call BuildGoFiles()<CR>
autocmd FileType go nmap <silent> <Leader>r  <Plug>(go-run)
autocmd FileType go nmap <silent> <Leader>t  <Plug>(go-test)
autocmd FileType go nmap <silent> <Leader>i  <Plug>(go-install)
autocmd FileType go nmap <silent> <Leader>d  <Plug>(go-doc)
"---------------------------------------------------------------------
" rust.vim
"---------------------------------------------------------------------
if trim(system('uname -s')) ==? 'Darwin'
    " macOS
    let g:rust_clip_command = 'pbcopy'
else
    " Linux
    let g:rust_clip_command = 'xclip -selection clipboard'
endif
let g:rustfmt_autosave = 1
let g:rustfmt_emit_files = 1
let g:rustfmt_fail_silently = 0
let g:rust_conceal = 0
let g:rust_fold = 1
let g:rust_recommended_style = 1
"---------------------------------------------------------------------
" vim-markdown
"---------------------------------------------------------------------
" Enable folding
let g:vim_markdown_folding_disabled = 0
" Fold in python-mode:
let g:vim_markdown_folding_style_pythonic = 1
" Disable all vim-markdown key bindings
let g:vim_markdown_no_default_key_mappings = 1
" Autoshrink TOCs
let g:vim_markdown_toc_autofit = 1
" Indentation for new lists. We don't insert bullets as it doesn't play
" nicely with `gq` formatting
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_auto_insert_bullets = 0
" Filetype aliases for fenced code blocks:
let g:vim_markdown_fenced_languages = [
        \'c++=cpp',
        \'rs=rust',
        \'py=python',
        \'js=javascript',
        \'ts=typescript',
        \'bash=sh',
        \'viml=vim',
        \]
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_json_frontmatter = 1
" Support inline latex for math
let g:vim_markdown_math = 1
" Format strike-through text
let g:vim_markdown_strikethrough = 1
" Support markdown concealing
let g:vim_markdown_conceal = 2
