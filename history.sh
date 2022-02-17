sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
curl https://raw.githubusercontent.com/mbadolato/iTerm2-Color-Schemes/master/schemes/Belafonte%20Night.itermcolors > BelafonteNight.itermcolors
brew install tree htop
brew install cmake
xcode-select --install
brew uninstall vim macvim
brew install vim --HEAD
brew uninstall macvim && brew unlink macvim
brew unlink macvim
brew install vim --HEAD
brew install shellcheck
softwareupdate --all --install --force
brew install cmake python mono go nodejs java\nsudo ln -sfn /usr/local/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk
python3 install.py --all
command -v rg >/dev/null 2>&1 || cargo install ripgrep\ncommand -v fd >/dev/null 2>&1 || cargo install fd-find\ncommand -v sk >/dev/null 2>&1 || cargo install skim\ncommand -v hx >/dev/null 2>&1 || cargo install hx\ncommand -v broot >/dev/null 2>&1 || cargo install broot\ncommand -v procs >/dev/null 2>&1 || cargo install procs\ncommand -v dust >/dev/null 2>&1 || cargo install du-dust\ncommand -v bat >/dev/null 2>&1 || cargo install bat\ncommand -v hyperfine >/dev/null 2>&1 || cargo install hyperfine\ncommand -v hexyll >/dev/null 2>&1 || cargo install hexyl\ncommand -v tokei >/dev/null 2>&1 || cargo install tokei
