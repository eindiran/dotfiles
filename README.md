# dotfiles
This repo contains my .rc files for bash, zsh, vim, tmux, etc. Mainly this repo exists to keep backup copies of my `.zshrc`, `.vimrc`, `.tmux.conf` and `newsboat` URLs file.

Check the `misc` directory for an assortment of random configuration/dotfiles.

## Installation
On a Debian or Ubuntu machine, you can run the script `install_dotfiles.sh` to install the dotfiles and all necessary packages.

```bash
cd dotfiles
./install_dotfiles.sh
```

`install_dotfiles.sh` calls into `shells/install_zshrc.sh` to install `.zshrc` and all base-utility packages. Note that it doesn't install the `.bashrc` file, so if you want a non-ZSH shell, that will need to be setup manually.
