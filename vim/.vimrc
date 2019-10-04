"---------------------------------------------------------------------
" FILE: .vimrc
" AUTHOR: Elliott Indiran <eindiran@uchicago.edu>
" DESCRIPTION: Config file for Vim
" CREATED: Thu 06 Jul 2017
" LAST MODIFIED: Fri 04 Oct 2019
" VERSION: 1.1.1
"---------------------------------------------------------------------
set nocompatible
" This makes it so vim doesn't need to behave like vi
" which allows it to use plugins through Vundle
set encoding=utf-8
" Work with UTF-8
"---------------------------------------------------------------------
filetype off
"---------------------------------------------------------------------
" Preparing to launch Vim Package manager (Vundle)
" Setting the Runtime Path
set rtp+=~/.vim/bundle/Vundle.vim
"---------------------------------------------------------------------
call vundle#begin()
Plugin 'VundleVim/Vundle.vim' " Vundle itself
Plugin 'w0rp/ale' " Multi lang linting manager
Plugin 'WolfgangMehner/awk-support' " awk syntax and inline code running
Plugin 'vim-scripts/bash-support.vim' " Run bash commands inline
Plugin 'nfvs/vim-perforce' " Integrations w/ p4
Plugin 'apalmer1377/factorus' " Easier refactoring
Plugin 'flazz/vim-colorschemes' " Adds options for color-schemes
Plugin 'wakatime/vim-wakatime' " Wakatime
Plugin 'rust-lang/rust.vim' " Rust syntax highlighting
Plugin 'godlygeek/tabular' " Dependency for MD syntax
Plugin 'plasticboy/vim-markdown' " MD syntax
Plugin 'sjurgemeyer/vimport' " Gradle/Groovy imports
Plugin 'klen/python-mode' " python-mode
Plugin 'baabelfish/nvim-nim' " Support for nim syntax
Plugin 'tmhedberg/SimpylFold' " Do folding
Plugin 'nvie/vim-flake8'
Plugin 'scrooloose/nerdtree' " File browsing
Plugin 'jistr/vim-nerdtree-tabs' " Using tabs
Plugin 'leafgarland/typescript-vim'
Plugin 'z0mbix/vim-shfmt', { 'for': 'sh' } " shfmt -- shell script formatter
call vundle#end()
"Bundle 'Valloric/YouCompleteMe'
"---------------------------------------------------------------------
filetype plugin indent on
"---------------------------------------------------------------------
" Syntax
"---------------------------------------------------------------------
let NERDTreeIgnore=['\.pyc$', '\~$'] "ignore files in NERDTree
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
" Get Tagbar to be toggleable
"---------------------------------------------------------------------
nmap <F8> :TagbarToggle<CR>
"---------------------------------------------------------------------
" Colors <background, syntax colors>
"---------------------------------------------------------------------
set background=dark " options: <light, dark>
colorscheme solarized " options: <solarized, molokai, wombat, etc.>
"---------------------------------------------------------------------
" Misc
"---------------------------------------------------------------------
set hidden " Helps windows by not allowing buffers to tamper w/ them
set backspace=indent,eol,start
let g:vimwiki_list = [{'path': '~/.wiki/'}]
let g:ycm_filetype_whitelist = {'*': 1}
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
set tabstop=4           " 4 space per tab press
set expandtab           " use spaces for tabs; why would you use tabs?
set softtabstop=4       " 4 space per tab press
set shiftwidth=4
set shiftround
"---------------------------------------------------------------------
" Indenting behavior
"---------------------------------------------------------------------
set autoindent
set copyindent
"---------------------------------------------------------------------
" UI Layout
"---------------------------------------------------------------------
set ruler
set wrap                " Do line wrapping
set number              " show line numbers
set ignorecase          " ignore case when searching
set hlsearch            " highlight all matches
set smartcase
set clipboard=unnamedplus " See here: vim.wikia.com/wiki/VimTip21
"---------------------------------------------------------------------
set list
set listchars=tab:▸·,trail:·,nbsp:·
" The above shows what whitespace is tabs
"---------------------------------------------------------------------
set wildignore=*.swp,*.bak,*.pyc,*.class,*.o
" Ignore these (this is like a gitignore)
"---------------------------------------------------------------------
set visualbell  " don't beep
set noerrorbells  " don't beep
"---------------------------------------------------------------------
" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap
"---------------------------------------------------------------------
" lets j,k behave more naturally on wrapped lines
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
" maps <F5> key to copying the entire text file to the system clipboard
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
    :%!python3 -c "import json, sys, collections; print(json.dumps(json.load(sys.stdin, objectpairshook=collections.OrderedDict), indent=4))"
endfunction
" Now add a mapping `=j` to this function
nmap =j :%!python -m json.tool<CR>
"---------------------------------------------------------------------
" Format XML using Python's minidom + some command-mode nonsense
"---------------------------------------------------------------------
function! FormatXML()
    :%!python3 -c "import xml.dom.minidom, sys; print(xml.dom.minidom.parse(sys.stdin).toprettyxml())"
endfunction
" Now add a mapping `=x` to this function
nmap =x :call FormatXML()<CR>:%s/\t/  /g<CR>:%s/ \+$//<CR>:g/^$/d<CR>
" Since this also works for HTML, add a mapping for `=h`
nmap =h =x
"---------------------------------------------------------------------
" pymode settings
"---------------------------------------------------------------------
let g:pymode_rope = 0 " Don't use Rope
let g:pymode_rope_completion = 0 " Don't use autocomplete via Rope
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_completion_on_dot = 0
let g:pymode_folding = 0 " Do function folding, but not in Pymode
let g:pymode_quickfix_maxheight = 4 " Max height of cwindow
let g:pymode_motion = 1
let g:pymode_lint = 1 " Use linting = 1; don't = 0
let g:pymode_python = 'python3'
let g:pymode_options_max_line_length = 100
let g:pymode_trim_whitespaces = 1 " remove trailing whitespace on save
let g:pymode_options_colorcolumn = 1 " Line indicating max line len
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
" python with virtualenv support
py3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    exec(compile(open(activate_this, "rb").read(), activate_this, 'exec'), dict(__file__=activate_this))
EOF
