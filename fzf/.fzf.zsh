# Setup fzf
# ---------
if [[ ! "$PATH" == */home/eindiran/.fzf/bin* ]]; then
  export PATH="$PATH:/home/eindiran/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/eindiran/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/eindiran/.fzf/shell/key-bindings.zsh"
