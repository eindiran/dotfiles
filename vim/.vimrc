"---------------------------------------------------------------------
" FILE: .vimrc
" AUTHOR: Elliott Indiran <elliott.indiran@protonmail.com>
" DESCRIPTION: Config file for Vim
" CREATED: Thu 06 Jul 2017
" LAST MODIFIED: Tue 01 Feb 2022
" VERSION: 1.2.3
"---------------------------------------------------------------------
set nocompatible
" This makes it so vim doesn't need to behave like vi
" which allows it to use plugins through Vundle.
set encoding=utf-8
" Work with UTF-8
set autoread
" Use `autoread`, for `vim-tmux-focus-events`
"---------------------------------------------------------------------
filetype off
"---------------------------------------------------------------------
" Preparing to launch Vim Package manager (Vundle)
" Setting the Runtime Path
set rtp+=~/.vim/bundle/Vundle.vim
"---------------------------------------------------------------------
call vundle#begin()
"---------------------------------------------------------------------
" General plugins:
"---------------------------------------------------------------------
Plugin 'VundleVim/Vundle.vim'                 " Vundle itself
Plugin 'Valloric/YouCompleteMe'               " Code Completion plugin
Plugin 'w0rp/ale'                             " Multi lang linting manager
Plugin 'vim-airline/vim-airline'              " Use the vim-airline status bar
Plugin 'vim-airline/vim-airline-themes'       " Setup the theme of the status bar
Plugin 'tmux-plugins/vim-tmux'                " For vim-tmux integration
Plugin 'tmux-plugins/vim-tmux-focus-events'   " For vim-tmux integration
Plugin 'roxma/vim-tmux-clipboard'             " For vim-tmux integration, for the clipboard
Plugin 'vim-scripts/bash-support.vim'         " Run bash commands inline
Plugin 'nfvs/vim-perforce'                    " Integration w/ p4
Plugin 'tpope/vim-fugitive'                   " Integration w/ git
Plugin 'flazz/vim-colorschemes'               " Adds options for color-schemes
Plugin 'godlygeek/tabular'                    " Dependency for MD syntax
Plugin 'tmhedberg/SimpylFold'                 " Do folding
Plugin 'scrooloose/nerdtree'                  " File browsing
Plugin 'jistr/vim-nerdtree-tabs'              " Using tabs
"---------------------------------------------------------------------
" Filetype specific plugins:
"---------------------------------------------------------------------
Plugin 'WolfgangMehner/awk-support', { 'for': 'awk' }  " awk syntax and inline code running
Plugin 'elzr/vim-json', { 'for': 'json' }              " JSON formatting, highlighting and folding
Plugin 'plasticboy/vim-markdown', { 'for': 'md' }      " Markdown syntax
Plugin 'nvie/vim-flake8', { 'for': 'py' }              " Formatting for Python
Plugin 'rust-lang/rust.vim', { 'for': 'rs' }           " Rust syntax highlighting
Plugin 'z0mbix/vim-shfmt', { 'for': 'sh' }             " shfmt -- shell script formatter
Plugin 'leafgarland/typescript-vim', { 'for': 'tsx' }  " TypeScript support
call vundle#end()
"---------------------------------------------------------------------
filetype plugin indent on
"---------------------------------------------------------------------
" Syntax
"---------------------------------------------------------------------
let NERDTreeIgnore=['\.pyc$', '\~$'] " Ignore files in NERDTree
" `syntax enable` is prefered to `syntax on`
if !exists("g:syntax_on")
    syntax enable
endif
"---------------------------------------------------------------------
" Perforce -- Some of these macros were gifted to me by Scott Conrad.
"---------------------------------------------------------------------
" The p4 plugin is missing some key features which are replicated here.
" Each macro begins "<comma><p>" and is usually ended by the first
" letter of the command.
" `p4 sync`
nmap ,ps :!p4 sync <C-R>=expand("%")<CR>
" `p4 add` (ie for adding new files)
nmap ,pa :!p4 add <C-R>=expand("%")<CR><CR>
" `p4 edit` (existing files)
nmap ,pe :!p4 edit <C-R>=expand("%")<CR><CR>
" `p4 info`
nmap ,pi :!p4 info<CR>
" `p4 revert`
nmap ,pr :!p4 revert <C-R>=expand("%")<CR>
" `p4 filelog`
nmap ,pfl :!p4 filelog <C-R>=expand("%")<CR>
" `p4 opened`
nmap ,po :!p4 opened <C-R>=expand("%")<CR>
" `p4 diff`
nmap ,pd :!p4 diff <C-R>=expand("%")<CR>
"---------------------------------------------------------------------
" Setup ALE:
"---------------------------------------------------------------------
let g:ale_lint_on_insert_leave = 0
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_save = 1
" Don't lint Java code, as the import functionality is garbage:
let g:ale_linters = {
    \ 'java': [],
    \ }
"---------------------------------------------------------------------
" Setup airline status bar:
"---------------------------------------------------------------------
" Support using the status bar with ALE:
let g:airline#extensions#ale#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='base16_gruvbox_dark_hard'
" Get Tagbar to be toggleable:
nmap <F8> :TagbarToggle<CR>
"---------------------------------------------------------------------
" Allow writes to files owned by root using `w!!`
"---------------------------------------------------------------------
cnoremap w!! w !sudo tee %
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
let g:ycm_clangd_binary_path = trim(system('brew --prefix llvm')).'/bin/clangd'
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
if system('uname -s') == "Darwin\n"
    " macOS - see here:
    " https://stackoverflow.com/questions/17561706/vim-yank-does-not-seem-to-work
    set clipboard=unnamed
else
    " Linux - see here: vim.wikia.com/wiki/VimTip21
    set clipboard=unnamedplus
endif
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
" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nmap ,cw :bcw
"---------------------------------------------------------------------
" Maps <F5> key to copying the entire text file to the system clipboard
nnoremap <silent> <F5> :%y+ <CR>
"---------------------------------------------------------------------
:let g:LargeFile=100
"---------------------------------------------------------------------
" Set Language File Extensions For Those Not Natively Supported
"---------------------------------------------------------------------
" *.groovy & *.gradle --> Groovy
au BufNewFile,BufRead *.groovy,*.gradle  setf groovy
" *.yaml,*.yml --> YAML
au BufNewFile,BufRead *.yaml,*.yml so ~/.vim/yaml.vim
" *.ts, *.tsx --> TypeScript
au BufNewFile,BufRead *.ts,*.tsx setfile typescript
"---------------------------------------------------------------------
" Do Automatic Timestamping
"---------------------------------------------------------------------
autocmd! BufWritePre * :call s:timestamp()
" Uses 'autocmd' to update timestamp when saving
function! s:timestamp()
    " Matches "[Last] (Change[d]|Update[d]|Modified): "
    " Case insensitively. Replaces everything after that w/ timestamp
    " in format: "FRI 07 JUL 2017"
    let pat = '\(\(Last\|LAST\)\?\s*\([Cc]hanged\|CHANGED\|[Mm]odified\|MODIFIED\|[Uu]pdated\?\|UPDATED\?\)\s*:\s*\).*'
    let rep = '\1' . strftime("%a %d %b %Y")
    call s:subst(1, 20, pat, rep)
    " Hardcoded to first 20 lines
endfunction
"---------------------------------------------------------------------
" Substitute within a line
" This function was taken from timestamp.vim
"---------------------------------------------------------------------
function! s:subst(start, end, pat, rep)
    let lineno = a:start
    while lineno <= a:end
    let curline = getline(lineno)
    if match(curline, a:pat) != -1
        let newline = substitute( curline, a:pat, a:rep, '' )
        if( newline != curline )
        " Only substitute if we made a change
        "silent! undojoin
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
    if(&relativenumber == 1)
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction
"---------------------------------------------------------------------
" Format JSON using Python's json.tool
"---------------------------------------------------------------------
function! FormatJSON()
    :%!jq .
endfunction
" Now add a mapping `=j` to this function
nmap =j :call FormatJSON()<CR>
"---------------------------------------------------------------------
" Format XML using Python's minidom + some command-mode nonsense
"---------------------------------------------------------------------
function! FormatXML()
    :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
endfunction
" Now add a mapping `=x` to this function
nmap =x :call FormatXML()<CR>:%s/\t/  /g<CR>:%s/ \+$//<CR>:g/^$/d<CR>
" Note that this also works for HTML, but we want to keep =h for our
" hex editing below.
"---------------------------------------------------------------------
" Format hex using `xxd`
"---------------------------------------------------------------------
function! FormatHex()
    set ft=xxd
    :%!xxd
endfunction
" Add a mapping to `=h`
nmap =h :call FormatHex()<CR>
" Once editing is complete, use =b to go back to binary
function! FormatBinary()
    :%!xxd -r
endfunction
nmap =b :call FormatBinary()<CR>
"---------------------------------------------------------------------
" pymode settings
"---------------------------------------------------------------------
let g:pymode_rope=0                " Don't use Rope
let g:pymode_rope_completion=0     " Don't use autocomplete via Rope
let g:pymode_rope_lookup_project=0
let g:pymode_rope_completion_on_dot=0
let g:pymode_folding=0             " Don't do function folding
let g:pymode_quickfix_maxheight=4  " Max height of cwindow
let g:pymode_motion=1
let g:pymode_lint=1                " Use linting = 1; don't = 0
let g:pymode_python='python2'
let g:pymode_options_max_line_length=100
let g:pymode_trim_whitespaces=1    " Remove trailing whitespace on save
let g:pymode_options_colorcolumn=1 " Line indicating max line len
"---------------------------------------------------------------------
" SimpylFold
"---------------------------------------------------------------------
let g:SimpylFold_docstring_preview=1
"---------------------------------------------------------------------
" Other
"---------------------------------------------------------------------
set splitbelow
set splitright
" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Enable folding
set foldmethod=indent
set foldlevel=99
" Unfold w/ spacebar
nnoremap <space> za
