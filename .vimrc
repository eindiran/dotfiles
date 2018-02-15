"---------------------------------------------------------------------
" FILE: .vimrc
" AUTHOR: Elliott Indiran <eindiran@uchicago.edu>
" DESCRIPTION: Config file for Vim
" CREATED: Thu 06 Jul 2017
" LAST MODIFIED: Thu 15 Feb 2018
" VERSION: 1.0.4
"---------------------------------------------------------------------
set nocompatible
" This makes it so vim doesn't need to behave like vi
" which allows it to use plugins through Vundle
"---------------------------------------------------------------------
filetype off 
"---------------------------------------------------------------------
" Preparing to launch Vim Package manager (Vundle)
" Setting the Runtime Path
set rtp+=~/.vim/bundle/Vundle.vim
"---------------------------------------------------------------------
call vundle#begin()
Plugin 'VundleVim/Vundle.vim' " Vundle itself
Plugin 'tpope/vim-fugitive' " Git plugin
Plugin 'w0rp/ale' " Multi lang linting manager
Plugin 'WolfgangMehner/awk-support' " awk syntax and inline code running
Plugin 'vim-scripts/bash-support.vim' " Run bash commands inline
Plugin 'nfvs/vim-perforce' " Integrations w/ p4
Plugin 'apalmer1377/factorus' " Easier refactoring
Plugin 'flazz/vim-colorschemes' " Adds options for color-schemes
Plugin 'wakatime/vim-wakatime' " Wakatime
Plugin 'rust-lang/rust.vim' " Rust syntax highlighting
Plugin 'rustushki/JavaImp.vim' " JavaDocs and import statement management
Plugin 'godlygeek/tabular' " Dependency for MD syntax
Plugin 'plasticboy/vim-markdown' " MD syntax
Plugin 'sjurgemeyer/vimport' " Gradle/Groovy imports
Plugin 'klen/python-mode' " python-mode
Plugin 'baabelfish/nvim-nim' " Support for nim syntax
call vundle#end()
"---------------------------------------------------------------------
filetype plugin indent on
"---------------------------------------------------------------------
" Setup for JavaImp
let g:JavaImpDataDir = "/home/eindiran/vim/JavaImp"
" Temp dir for JavaImp to work in
let g:JavaImpPaths = "/home/eindiran/Workspace"
" Paths to top level Java project dirs
" REVISIT: Add all paths required, esp. once this is on my work machine.
"---------------------------------------------------------------------
" Syntax
"---------------------------------------------------------------------
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
set listchars=tab:▸·
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
" pymode settings
"---------------------------------------------------------------------
let g:pymode_rope = 0
let g:pymode_rope_completion = 0
let g:pymode_rope_lookup_project = 0
let g:pymode_rope_completion_on_dot = 0
let g:pymode_folding = 1
let g:pymode_quickfix_maxheight = 4 " Max height of cwindow
let g:pymode_motion = 1
let g:pymode_lint = 1 " Use linting
let g:pymode_lint_on_write = 1 " Lint on modified saves
let g:pymode_python = 'python3'
let g:pymode_options_max_line_length = 100
let g:pymode_trim_whitespaces = 1 " remove trailing whitespace on save
" let g:pymode_lint_checkers = ['pylint'] " only lint w/ pylint
let g:pymode_options_colorcolumn = 1 " Line indicating max line len
let g:pymode_lint_cwindow = 1 " When the linter complains open cwindow
"---------------------------------------------------------------------
" Map <Ctrl> + <O> to open the pymode quickfix window
" and <Ctrl> + <G> to close it.
"---------------------------------------------------------------------
nmap <C-g><C-o> <Plug>window:quickfix:toggle
"---------------------------------------------------------------------
