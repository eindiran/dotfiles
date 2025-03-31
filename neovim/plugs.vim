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
  \| PlugInstall --sync | source ~/.config/nvim/plugs.vim
  \| endif
" Now call vim-plug begin:
call plug#begin()
"---------------------------------------------------------------------
" General plugins:
"---------------------------------------------------------------------
Plug 'ycm-core/YouCompleteMe'              " Code Completion plugin
Plug 'dense-analysis/ale'                  " Multi lang linting manager
Plug 'nvim-lualine/lualine.nvim'           " Status line for nvim
Plug 'nvim-tree/nvim-web-devicons'         " Icon support for lualine.nvim
Plug 'tpope/vim-surround'                  " Automate parens, quotes, etc
Plug 'tpope/vim-commentary'                " Commenting keybinds
Plug 'tpope/vim-fugitive'                  " Integration w/ git
Plug 'tpope/vim-repeat'                    " Make . handle commentary and surround
Plug 'flazz/vim-colorschemes'              " Adds options for color-schemes
Plug 'scrooloose/nerdtree'                 " File browsing
Plug 'jistr/vim-nerdtree-tabs'             " Using tabs
Plug 'junegunn/fzf.vim'                    " FZF bindings and delta bindings
Plug 'ludovicchabant/vim-gutentags'        " Tag file generator
Plug 'puremourning/vimspector'             " Debugger
"---------------------------------------------------------------------
" Filetype specific plugins:
"---------------------------------------------------------------------
Plug 'eindiran/awk-support'                " awk support
Plug 'eindiran/c-support'                  " C/C++ support
Plug 'eindiran/bash-support.vim'           " Shell scripting integration
Plug 'tmhedberg/SimpylFold'                " Python folding
Plug 'rust-lang/rust.vim'                  " Rust support
Plug 'ziglang/zig.vim'                     " Zig support
Plug 'posva/vim-vue'                       " Vue support
Plug 'godlygeek/tabular'                   " Markdown dep
Plug 'preservim/vim-markdown'              " Markdown
Plug 'fatih/vim-go'                        " Go support
call plug#end()
