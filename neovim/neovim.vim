"'---------------------------------------------------------------------
" FILE: init.vim
" AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
" DESCRIPTION: Config file for NeoVim
" CREATED: Sun 21 Jul 2024
" LAST MODIFIED: Tue 17 Dec 2024
" VERSION: 1.0.4
"---------------------------------------------------------------------
" NeoVim specifics:
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
" Main setup:
set nocompatible
" This makes it so vim doesn't need to behave like vi
" which allows it to use plugins and a variety of other goodies.
set encoding=utf-8
" Work with UTF-8
" Use `autoread`, for `vim-tmux-focus-events`
set autoread
" Disable writing backups before overwriting files:
set nobackup
" Force backup swap files:
set writebackup
" Enable filetype detection, with plugin and indent; see
" :help filetype for more info.
filetype plugin indent on
" `syntax enable` is prefered to `syntax on`
if !exists('g:syntax_on')
    syntax enable
endif
" Source plugins w/ vim-plug:
source ~/.config/nvim/plugs.vim
"---------------------------------------------------------------------
" vimspector
"---------------------------------------------------------------------
let g:vimspector_install_gadgets = ['debugpy', 'CodeLLDB']
nmap <silent> <Leader><F3>  <Plug>VimspectorStop
nmap <silent> <Leader><F4>  <Plug>VimspectorRestart
nmap <silent> <Leader><F5>  <Plug>VimspectorContinue
nmap <silent> <Leader><F6>  <Plug>VimspectorPause
nmap <silent> <Leader><F7>  <Plug>VimspectorRunToCursor
nmap <silent> <Leader><F8>  <Plug>VimspectorToggleConditionalBreakpoint
nmap <silent> <Leader><F9>  <Plug>VimspectorToggleBreakpoint
nmap <silent> <Leader><F10> <Plug>VimspectorStepOver
nmap <silent> <Leader><F11> <Plug>VimspectorStepInto
nmap <silent> <Leader><F12> <Plug>VimspectorStepOut
nmap <silent> <Leader>di    <Plug>VimspectorBalloonEval
xmap <silent> <Leader>di    <Plug>VimspectorBalloonEval
nmap <silent> =<F11>        <Plug>VimspectorUpFrame
nmap <silent> =<F12>        <Plug>VimspectorDownFrame
nmap <silent> <Leader>b     <Plug>VimspectorBreakpoints
nmap <silent> <Leader><C-D> <Plug>VimspectorDisassemble
"---------------------------------------------------------------------
" NERDTree
"---------------------------------------------------------------------
" Start NERDTree automatically if vim is started with a filename
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0
    \&& !exists('s:std_in')
    \| NERDTree
    \| endif
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1
    \&& winnr('$') == 1
    \&& exists('b:NERDTree')
    \&& b:NERDTree.isTabTree()
    \| call feedkeys(":quit\<CR>:\<BS>")
    \| endif
" Ignore files in NERDTree
let NERDTreeIgnore=[
    \'\.pyc$',
    \'\~$',
    \'\.git$',
    \'\.idea$',
    \'\.vscode$',
    \'\.history$',
    \'\..*\.sw[op]$'
    \]
let NERDTreeShowHidden=1  " Show hidden/dot files by default
" Open current working directory with F11
nmap <F11> :NERDTreeCWD<CR>
" Toggle NerdTree with F12
nmap <F12> :NERDTreeToggle<CR>
"---------------------------------------------------------------------
" FZF.vim
"---------------------------------------------------------------------
if trim(system('uname -s')) ==? 'Darwin'
    set rtp+=/opt/homebrew/opt/fzf
else
    " FZF installed in home directory
    set rtp+=~/.fzf
endif
let g:fzf_vim = {}
let g:fzf_vim.preview_window = ['hidden,right,50%,<70(up,40%)', 'ctrl-/']
let g:fzf_vim.commits_log_options = '--graph --color=always'
let g:fzf_vim.tags_command = 'ctags -R'
let g:fzf_vim.listproc_rg = { list -> fzf#vim#listproc#location(list) }
" FZF key-mappings:
nmap <silent> <Leader><Tab> <Plug>(fzf-maps-n)
xmap <silent> <Leader><Tab> <Plug>(fzf-maps-x)
omap <silent> <Leader><Tab> <Plug>(fzf-maps-o)
imap <C-X><C-W> <Plug>(fzf-complete-word)
imap <expr> <C-X><C-P> fzf#vim#complete#path('fd')
imap <expr> <C-X><C-F> fzf#vim#complete#path('fd -t f')
imap <C-X><C-L> <Plug>(fzf-complete-line)
imap <C-X><C-B> <Plug>(fzf-complete-buffer-line)
"---------------------------------------------------------------------
" Folding
"---------------------------------------------------------------------
" Enable folding
set foldmethod=syntax  " Fold by syntax rather than indent or manual
set foldlevelstart=99  " All folds open on file open; can be overriden
" on some filetypes/plugins. Eg vim-markdown folds much more aggressively
" Unfold w/ spacebar
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
" Reset folds with spacebar minus
nnoremap <silent> <Space>- :e!<CR>
" Totally unfold everything
nnoremap <silent> <Space>+ @=(foldlevel('.')?'zR':"\<Space>")<CR>
" Totally refold everything
nmap <silent> <Space>= zM<CR>
vnoremap <Space> zf
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
nmap <silent> =da :call DisableALE()<CR>
nmap <silent> =ea :call EnableALE()<CR>
nmap <silent> <F2> :call ToggleALE()<CR>
" Make the bar toggle w/ F10
" nmap <silent> <F10> :AirlineToggle<CR>
"---------------------------------------------------------------------
" Colors <background, syntax colors>
"---------------------------------------------------------------------
set background=dark   " options: <light, dark>
colorscheme gruvbox " options: <gruvbox, solarized, molokai, etc.>
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
" Spaces, Tabs, and indenting behavior:
"---------------------------------------------------------------------
set tabstop=4          " 4 space per tab press
set expandtab          " Use spaces for tabs
set softtabstop=4      " 4 space per tab press
set shiftwidth=4       " 4 spaces per shift (>)
set shiftround         " Round indentation to a multiple of shiftwidth
set virtualedit=all    " Allow movement/insert past the final char in a line
set autoindent         " Copy indent level from previous line
set copyindent         " Use the whitespace characters of the previous line
"---------------------------------------------------------------------
" UI
"---------------------------------------------------------------------
set ruler                 " Show line and char/column numbers
set wrap                  " Do line wrapping
set number                " Show line numbers
set hlsearch              " Highlight all matches
set visualbell            " Don't beep
set noerrorbells          " Don't beep
set hidden                " Helps windows by not allowing buffers to tamper w/ them
set backspace=indent,eol,start
" The below two lines show which whitespace is tabs vs spaces
set list
set listchars=tab:▸·,trail:·,nbsp:·
" Make vim use the system clipboard:
" macOS - see here: https://stackoverflow.com/questions/17561706/
" Linux - see here: https://vim.wikia.com/wiki/VimTip21
set clipboard^=unnamed,unnamedplus
" Maps <F4> key to copying the entire text file to the system clipboard
nnoremap <silent> <F4> :%y+ <CR>
"---------------------------------------------------------------------
" Case sensitivity:
"---------------------------------------------------------------------
set ignorecase            " Ignore case when searching
set smartcase             " Case-insensitive if all chars are lowercase
" Map F9 to case sensitivity toggle:
nnoremap <silent> <F9> :set ignorecase! ignorecase?<CR>:set smartcase! smartcase?<CR>
"---------------------------------------------------------------------
" Dynamically set wildignore from .gitignore:
" Try to use local gitignore, or global one if we can't find or can't
" load the local one.
let gitignore_file = (
    \filereadable('.gitignore')
    \? '.gitignore'
    \: '~/.gitignore'
\)
if filereadable(gitignore_file)
    let ignore_string = ''
    for line in readfile(gitignore_file)
        let line = substitute(line, '\s|\n|\r', '', 'g')
        if line =~ '^<<\+' | continue | endif  " Git conflict marker
        if line =~ '^>>\+' | continue | endif  " Git conflict marker
        if line =~ '^==\+' | continue | endif  " Git conflict marker
        if line =~ '^ *#'  | continue | endif  " Comment line
        if line =~ '^\s*$' | continue | endif  " Whitespace-only line
        if line =~ '^!'    | continue | endif  " Negation line
        " Continuation lines:
        if line =~ '/$' | let ignore_string .= ',' . line . '*' | continue | endif
        let ignore_string .= ',' . line
    endfor
    let ignore_string = substitute(ignore_string, ',,\+', ',', 'g')
    let ignore_string = join(
        \uniq(
            \sort(
                \split(ignore_string, ',')
            \)
        \),
        \',',
    \)
    let exec_string = 'set wildignore+='.substitute(
        \ignore_string,
        \'^,\+',
        \'',
        \'g'
    \)
    execute exec_string
endif
"---------------------------------------------------------------------
" Paragraph formatting
"---------------------------------------------------------------------
" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap
" Remove all trailing whitespace by pressing F6
nnoremap <F6> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
"---------------------------------------------------------------------
" Window controls
"---------------------------------------------------------------------
set splitbelow
set splitright
" Let j and k behave more naturally on wrapped lines
onoremap <silent> j gj
onoremap <silent> k gk
" Easy window navigation
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l
nmap ,cw :bcw
"---------------------------------------------------------------------
" Buffer controls
"---------------------------------------------------------------------
" Cycle through the buffers with \\ (forward) and \| (backwards)
nnoremap <nowait><silent> <Leader><Leader> :bn<CR>
nnoremap <nowait><silent> <Leader><Bar> :bp<CR>
" Hop to the alternate file buffer with -
nnoremap <silent> - <C-^>
"---------------------------------------------------------------------
" Set behaviors on buffer load for specific filetypes:
"---------------------------------------------------------------------
" *.groovy & *.gradle --> Groovy
au BufNewFile,BufRead *.groovy,*.gradle setf groovy
" *.yaml,*.yml --> YAML
au BufNewFile,BufRead *.yaml,*.yml set filetype=yaml foldmethod=indent
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" *.rst --> reStructuredText
au BufNewFile,BufRead *.rst set filetype=rst foldmethod=indent
" This autocmd will ensure we reformat using paragraph style
" after all lines ending in space; combined with ALE settings, this
" will then remove the space on save.
" SEE: `:help fo-table` for more info on these.
" autocmd FileType rst setlocal formatoptions+=awn
" DISABLED FOR NOW
" *.md --> Markdown
" This is not required if using vim-markdown
" au BufNewFile,BufRead *.md set filetype=markdown
" Set the conceallevel to hide by default
autocmd FileType markdown set conceallevel=2
"---------------------------------------------------------------------
" Do Automatic Versioning
"---------------------------------------------------------------------
" autocmd! BufWritePre * :call UpdatePatchVersion()
" Uses 'autocmd' to update the patch version when saving - disabled
function! UpdatePatchVersion()
    :1,20s@\(REVISION\s*:\s*\|VERSION\s*:\s*\)\(v\?\d\+\.\)\(\d\+\.\)\(\d\+\)@\=submatch(1) . submatch(2) . submatch(3) . (submatch(4) + 1)@
    " Hardcoded to first 20 lines
endfunction
nmap <silent> =vp :call UpdatePatchVersion()<CR>
function! UpdateMinorVersion()
    :1,20s@\(REVISION\s*:\s*\|VERSION\s*:\s*\)\(v\?\d\+\.\)\(\d\+\)\(\.\)\(\d\+\)@\=submatch(1) . submatch(2) . (submatch(3) + 1) . submatch(4) . 0@
    " Hardcoded to first 20 lines
endfunction
nmap <silent> =vv :call UpdateMinorVersion()<CR>
function! UpdateMajorVersion()
    :1,20s@\(REVISION\s*:\s*\|VERSION\s*:\s*\)\(v\?\)\(\d\+\)\(\.\)\(\d\+\)\(\.\)\(\d\+\)@\=submatch(1) . submatch(2) . (submatch(3) + 1) . submatch(4) . 0 . submatch(6) . 0@
    " Hardcoded to first 20 lines
endfunction
nmap <silent> =vm :call UpdateMajorVersion()<CR>
"---------------------------------------------------------------------
" Do Automatic Timestamping
"---------------------------------------------------------------------
" autocmd! BufWritePre * :call UpdateTimestamp()
" Uses 'autocmd' to update timestamp when saving - disabled
function! UpdateTimestamp()
    " Matches "[LAST] (CHANGE[D]|UPDATE[D]|MODIFIED): "
    " Case sensitive. Replaces everything after that w/ timestamp
    " in format: "FRI 07 JUL 2017"
    let pat = '\(\(LAST\)\?\s*\(CHANGED\?\|MODIFIED\|UPDATED\?\)\s*:\s*\).*'
    let rep = '\1' . strftime("%a %d %b %Y")
    call s:subst(1, 20, pat, rep)
    " Hardcoded to first 20 lines
endfunction
nmap <silent> =t :call UpdateTimestamp()<CR>
"---------------------------------------------------------------------
" Substitute within a line
" This function was taken from timestamp.vim
"---------------------------------------------------------------------
function! s:subst(start, end, pat, rep)
    let lineno = a:start
    while lineno <= a:end
        let curline = getline(lineno)
        if match(curline, a:pat) != -1
            let newline = substitute(curline, a:pat, a:rep, '')
            if (newline != curline)
                " Only substitute if we made a change
                keepjumps call setline(lineno, newline)
            endif
        endif
        let lineno = lineno + 1
    endwhile
endfunction
"---------------------------------------------------------------------
" Toggle between relativenumber and norelativenumber
"---------------------------------------------------------------------
function! ToggleNumber()
    if (&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction
nmap <silent> =n :call ToggleNumber()<CR>
"---------------------------------------------------------------------
" Show all currently mapped keys
"---------------------------------------------------------------------
function! ShowAllMappedKeys()
    :map
endfunction
nmap <F1> :call ShowAllMappedKeys()<CR>
"---------------------------------------------------------------------
" Show the currently mapped Fn keys
"---------------------------------------------------------------------
function! ShowMappedFKeys()
    for i in range(1, 12)
        if !empty(mapcheck('<F'.i.'>'))
            execute 'map <F'.i.'>'
        endif
    endfor
endfunction
nmap <F8> :call ShowMappedFKeys()<CR>
"---------------------------------------------------------------------
" Format hex using `xxd`
"---------------------------------------------------------------------
function! FormatHex()
    set ft=xxd
    :%!xxd
endfunction
" Add a mapping to `=fh`
nmap <silent> =fh :call FormatHex()<CR>
" Once editing is complete, use =b to go back to binary
function! FormatBinary()
    :%!xxd -r
endfunction
" Add a mapping to `=fb`
nmap <silent> =fb :call FormatBinary()<CR>
"---------------------------------------------------------------------
" Format JSON using jq
"---------------------------------------------------------------------
function! FormatJSON()
    :%!jq .
endfunction
" Now add a mapping `=fj` to this function
nmap <silent> =fj :call FormatJSON()<CR>
"---------------------------------------------------------------------
" Format XML using Python's minidom + some command-mode nonsense
"---------------------------------------------------------------------
function! FormatXML()
    :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
endfunction
" Now add a mapping `=fx` to this function
nmap <silent> =fx :call FormatXML()<CR>:%s/\t/  /g<CR>:%s/ \+$//<CR>:g/^$/d<CR>:noh<CR>
" And `=fh` for HTML. This overrides the hex formatter above, so make it
" contingent on the filetype being .html
autocmd FileType html nmap <silent> =fh :call FormatXML()<CR>:%s/\t/  /g<CR>:%s/ \+$//<CR>:g/^$/d<CR>:noh<CR>
"---------------------------------------------------------------------
" SimpylFold
"---------------------------------------------------------------------
let g:SimpylFold_docstring_preview=1
let g:SimpylFold_fold_import=0
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
"---------------------------------------------------------------------
" Git
"---------------------------------------------------------------------
" Map search for git conflicts to `=c`
nmap =c /\v\<{7}\|\={7}\|\>{7}<CR>
" Map function that deletes the conflict under the cursor to `=d`
function! DeleteConflictSection()
    :,/\v(\<{7}|\={7}|\>{7})/-d
endfunction
nnoremap <silent> =d :call DeleteConflictSection()<CR>
nnoremap <Leader>gd :Gvdiff<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
"---------------------------------------------------------------------
" Commenting
"---------------------------------------------------------------------
" Add the following commenting commands in normal, visual,
" and operation-pending modes (select and insert excluded):
nnoremap <silent> =# <Plug>Commentary
nnoremap <silent> =/ <Plug>Commentary
xnoremap <silent> =# <Plug>Commentary
xnoremap <silent> =/ <Plug>Commentary
onoremap <silent> =# <Plug>Commentary
onoremap <silent> =/ <Plug>Commentary
" These are added because historically I didn't use vim-commentary
" and these were the bindings I used.
"---------------------------------------------------------------------
" Other
"---------------------------------------------------------------------
" Set the conceallevel manually in normal mode
nnoremap <silent> =cl :set conceallevel=2<CR>
nnoremap <silent> -cl :set conceallevel=0<CR>
" Undo last search highlighting by pressing enter again
nnoremap <nowait><silent> <CR> :noh<CR><CR>
" Delete messages buffer
nnoremap <nowait><silent> <C-C> :messages clear<CR>
" Allow writes to files owned by root using `w!!`
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <Bar> edit!
" Sort words in a line in normal mode:
nnoremap <silent> =sw :call setline('.', join(sort(split(getline('.'), ' ')), ' '))<CR>
nnoremap <silent> =sa :%!sort<CR>
nnoremap <silent> =sn :%!sort -n<CR>
