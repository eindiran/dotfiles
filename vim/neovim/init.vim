" Neovim-specific configuration:
" Mostly needed to bootstrap the .vimrc and Vundle plugins
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
set clipboard+=unnamedplus
