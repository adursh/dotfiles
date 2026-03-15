export PATH="$PATH:/Users/nvc/.local/bin"

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

alias ls="eza --color=always --git --icons=always"
alias cat="bat"
alias find="fd"
alias grep="rg"

eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.toml)"

# zsh-vi-mode
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
