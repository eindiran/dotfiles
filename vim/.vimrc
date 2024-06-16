"---------------------------------------------------------------------
" FILE: .vimrc
" AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
" DESCRIPTION: Config file for Vim
" CREATED: Thu 06 Jul 2017
" LAST MODIFIED: Sun 16 Jun 2024
" VERSION: 1.5.2
"---------------------------------------------------------------------
set nocompatible
" This makes it so vim doesn't need to behave like vi
" which allows it to use plugins and a variety of other goodies.
set encoding=utf-8
" Work with UTF-8
set autoread
" Use `autoread`, for `vim-tmux-focus-events`
set term=xterm-256color
"---------------------------------------------------------------------
" Enable filetype detection, with plugin and indent; see
" :help filetype for more info.
filetype plugin indent on
" `syntax enable` is prefered to `syntax on`
if !exists("g:syntax_on")
    syntax enable
endif
"---------------------------------------------------------------------
" vim-plug
"---------------------------------------------------------------------
" First setup vim-plug if required:
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source ~/.vimrc
  \| endif
" Now call vim-plug begin:
call plug#begin()
"---------------------------------------------------------------------
" General plugins:
"---------------------------------------------------------------------
Plug 'ycm-core/YouCompleteMe'              " Code Completion plugin
Plug 'puremourning/vimspector'             " Debugger
Plug 'dense-analysis/ale'                  " Multi lang linting manager
Plug 'vim-airline/vim-airline'             " Use the vim-airline status bar
Plug 'vim-airline/vim-airline-themes'      " Setup the theme of the status bar
Plug 'tmux-plugins/vim-tmux'               " For vim-tmux integration
Plug 'tmux-plugins/vim-tmux-focus-events'  " For vim-tmux integration
Plug 'roxma/vim-tmux-clipboard'            " For vim-tmux integration, for the clipboard
Plug 'tpope/vim-fugitive'                  " Integration w/ git
Plug 'flazz/vim-colorschemes'              " Adds options for color-schemes
Plug 'scrooloose/nerdtree'                 " File browsing
Plug 'jistr/vim-nerdtree-tabs'             " Using tabs
Plug 'junegunn/fzf.vim'                    " FZF bindings and delta bindings
Plug 'ludovicchabant/vim-gutentags'        " Tag file generator
"---------------------------------------------------------------------
" Filetype specific plugins:
"---------------------------------------------------------------------
Plug 'eindiran/awk-support'                         " awk support
Plug 'eindiran/c-support'                           " C/C++ support
Plug 'eindiran/bash-support.vim'                    " Shell scripting integration
Plug 'tmhedberg/SimpylFold'                         " Python folding
Plug 'rust-lang/rust.vim'                           " Rust support
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }  " Go support
Plug 'posva/vim-vue'                                " Vue support
call plug#end()
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
let NERDTreeIgnore=['\.pyc$', '\~$'] " Ignore files in NERDTree
" Open current working directory with F11
map <F11> :NERDTreeCWD<CR>
" Toggle NerdTree with F12
map <F12> :NERDTreeToggle<CR>
"---------------------------------------------------------------------
" FZF.vim
"---------------------------------------------------------------------
if trim(system('uname -s')) == "Darwin"
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
nmap <silent> <leader><Tab> <Plug>(fzf-maps-n)
xmap <silent> <leader><Tab> <Plug>(fzf-maps-x)
omap <silent> <leader><Tab> <Plug>(fzf-maps-o)
imap <C-X><C-K> <Plug>(fzf-complete-word)
imap <C-X><C-F> <Plug>(fzf-complete-path)
imap <C-X><C-L> <Plug>(fzf-complete-line)
"---------------------------------------------------------------------
" Folding
"---------------------------------------------------------------------
" Enable folding
set foldmethod=syntax  " Fold by syntax rather than indent or manual
set foldlevelstart=99  " All folds open on file open
" Unfold w/ spacebar
nnoremap <silent> <space> @=(foldlevel('.')?'za':"\<space>")<CR>
vnoremap <space> zf
"---------------------------------------------------------------------
" Setup ALE:
"---------------------------------------------------------------------
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_fix_on_save = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {
    \ 'c': ['clangd', 'clangcheck', 'clangtidy'],
    \ 'go': ['golangci_lint'],
    \ 'javascript': ['eslint'],
    \ 'python': ['ruff', 'mypy'],
    \ 'rust': ['cargo', 'rustc'],
    \ 'sh': ['shellcheck'],
    \ 'vue': ['eslint', 'stylelint', 'vls'],
    \ }
" Alias Vue to support linting/fixing/highlighting with all the
" relevant filetypes.
let g:ale_linter_aliases = {'vue': ['vue', 'css', 'javascript', 'html']}
" Don't enable fixers for all languages, as some plugins for languages
" already enable them (e.g. vim-go for Go)
let g:ale_fixers = {
    \ 'c': ['clangformat', 'clangtidy'],
    \ 'javascript': ['eslint', 'prettier'],
    \ 'python': ['ruff', 'ruff_format'],
    \ 'rust': ['rustfmt'],
    \ 'sh': ['shfmt'],
    \ 'vue': ['eslint', 'prettier'],
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ }
let g:ale_python_pylint_options = '--rcfile '.expand('~/.pylintrc')
let g:ale_sh_shfmt_options = '-i=4 -ln=bash -ci -kp'
nmap <silent> =aj :ALENext<CR>
nmap <silent> <leader>j :ALENext<CR>
nmap <silent> =ak :ALEPrevious<CR>
nmap <silent> <leader>k :ALEPrevious<CR>
nmap <silent> =ad :ALEGoToDefinition<CR>
nmap <silent> <leader>h :ALEHover<CR>
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
map <silent> <F2> :call ToggleALE()<CR>
"---------------------------------------------------------------------
" Setup airline status bar:
"---------------------------------------------------------------------
" Airline formatter:
let g:airline#extensions#tabline#formatter = 'default'
" Support using the status bar with ALE:
let g:airline#extensions#ale#enabled = 1
" Support using the status bar with YCM:
let g:airline#extensions#ycm#enabled = 1
" Support using the status bar with NerdTree:
let g:airline#extensions#nerdtree#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='base16_gruvbox_dark_hard'
" Make the bar toggle w/ F10
map <F10> :AirlineToggle<CR>
"---------------------------------------------------------------------
" Colors <background, syntax colors>
"---------------------------------------------------------------------
set background=dark   " options: <light, dark>
colorscheme gruvbox " options: <gruvbox, solarized, molokai, etc.>
" Can use wal to do dynamic color schemes with pywal
"---------------------------------------------------------------------
" Misc
"---------------------------------------------------------------------
set hidden " Helps windows by not allowing buffers to tamper w/ them
set backspace=indent,eol,start
let g:vimwiki_list=[{'path': '~/.wiki/'}]
"---------------------------------------------------------------------
" YouCompleteMe Configuration
"---------------------------------------------------------------------
if trim(system('uname -s')) == "Darwin"
    " On macOS, make sure we set up some fiddly bits for YCM
    let g:ycm_clangd_binary_path = trim(system('brew --prefix llvm')).'/bin/clangd'
    " let g:ycm_server_python_interpreter='/opt/homebrew/bin/python3'
endif
let g:ycm_filetype_whitelist={'*': 1}
let g:ycm_filetype_blacklist={
    \ 'notes':1,
    \ 'markdown':1,
    \ 'unite':1,
    \ 'tagbar':1,
    \ 'pandoc':1,
    \ 'qf':1,
    \ 'vimwiki':1,
    \ 'infolog':1,
    \ 'mail':1,
    \ 'org':1
    \}
"---------------------------------------------------------------------
" Spaces & Tabs
set tabstop=4          " 4 space per tab press
set expandtab          " Use spaces for tabs
set softtabstop=4      " 4 space per tab press
set shiftwidth=4       " "
set shiftround         " "
set virtualedit=all    " Allow typing past the final char in a line.
"---------------------------------------------------------------------
" Indenting behavior
"---------------------------------------------------------------------
set autoindent
set copyindent
"---------------------------------------------------------------------
" UI Layout
"---------------------------------------------------------------------
set ruler
set wrap                  " Do line wrapping
set number                " Show line numbers
set ignorecase            " Ignore case when searching
set hlsearch              " Highlight all matches
set smartcase
" macOS - see here:
" https://stackoverflow.com/questions/17561706/vim-yank-does-not-seem-to-work
" Linux - see here: vim.wikia.com/wiki/VimTip21
set clipboard^=unnamed,unnamedplus
"---------------------------------------------------------------------
set list
set listchars=tab:▸·,trail:·,nbsp:·
" The above shows what whitespace is tabs
"---------------------------------------------------------------------
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o
" Ignore these (this is like a gitignore)
"---------------------------------------------------------------------
set visualbell    " Don't beep
set noerrorbells  " Don't beep
"---------------------------------------------------------------------
" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap
"---------------------------------------------------------------------
" Let j and k behave more naturally on wrapped lines
onoremap <silent> j gj
onoremap <silent> k gk
"---------------------------------------------------------------------
set splitbelow
set splitright
" Easy window navigation
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l
nmap ,cw :bcw
"---------------------------------------------------------------------
" Maps <F5> key to copying the entire text file to the system clipboard
nnoremap <silent> <F5> :%y+ <CR>
" Remove all trailing whitespace by pressing F5
nnoremap <F6> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
"---------------------------------------------------------------------
:let g:LargeFile=100
"---------------------------------------------------------------------
" Set Language File Extensions For Those Not Natively Supported
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
autocmd FileType rst setlocal formatoptions+=awn
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
" Function for counting from start of a visual block
"---------------------------------------------------------------------
function Vline()
    return line(".")-line("'<")+1
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
autocmd FileType json nmap <silent> =fj :call FormatJSON()<CR>
"---------------------------------------------------------------------
" Format XML using Python's minidom + some command-mode nonsense
"---------------------------------------------------------------------
function! FormatXML()
    :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
endfunction
" Now add a mapping `=fx` to this function
autocmd FileType xml nmap <silent> =fx :call FormatXML()<CR>:%s/\t/  /g<CR>:%s/ \+$//<CR>:g/^$/d<CR>:noh<CR>
" And `=fh` for HTML. This overrides the hex formatter above.
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
autocmd FileType go nmap <silent> <leader>b :call BuildGoFiles()<CR>
autocmd FileType go nmap <silent> <leader>r  <Plug>(go-run)
autocmd FileType go nmap <silent> <leader>t  <Plug>(go-test)
autocmd FileType go nmap <silent> <leader>i  <Plug>(go-install)
autocmd FileType go nmap <silent> <leader>d  <Plug>(go-doc)
"---------------------------------------------------------------------
" rust.vim
"---------------------------------------------------------------------
if trim(system('uname -s')) == "Darwin"
    " macOS
    let g:rust_clip_command = 'pbcopy'
else
    " Linux
    let g:rust_clip_command = 'xclip -selection clipboard'
endif
"---------------------------------------------------------------------
" Git
"---------------------------------------------------------------------
" Map search for git conflicts to `=c`
nmap =c /\v\<{7}\|\={7}\|\>{7}<CR>
" Map function that deletes the conflict under the cursor to `=d`
function! DeleteConflictSection()
    :,/\v(\<{7}|\={7}|\>{7})/-d
endfunction
nmap <silent> =d :call DeleteConflictSection()<CR>
nnoremap <leader>gd :Gvdiff<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
"---------------------------------------------------------------------
" Commenting
"---------------------------------------------------------------------
" Add the following commenting commands in normal, visual,
" operation-pending, and select modes:
" Python-style commenting
noremap <silent> =# :s/^/#/<CR>:noh<CR>
noremap <silent> -# :s/^#//<CR>:noh<CR>
" Python block commenting
noremap <silent> =" :s/^/"""\r/<CR>:noh<CR>
noremap <silent> -" :s/.*""".*//<CR>:noh<CR>
" C-style commenting
noremap <silent> =/ :s/^/\/\//<CR>:noh<CR>
noremap <silent> -/ :s/^\/\///<CR>:noh<CR>
"---------------------------------------------------------------------
" Other
"---------------------------------------------------------------------
" Undo last search highlighting by pressing enter again
nnoremap <nowait><silent> <CR> :noh<CR><CR>
" Delete messages buffer
nnoremap <nowait><silent> <C-C> :messages clear<CR>
" Allow writes to files owned by root using `w!!`
cnoremap w!! w !sudo tee %
" Sort words in a line in normal mode:
nnoremap <silent> =sw :call setline('.', join(sort(split(getline('.'), ' ')), " "))<CR>
nnoremap <silent> =sa :%!sort<CR>
nnoremap <silent> =sn :%!sort -n<CR>
