export PATH="$PATH:/Users/nvc/.local/bin"

eval "$(zoxide init zsh)"
eval "$(fzf --zsh)"

alias ls="eza --color=always --git --icons=always"
alias cat="bat"
alias find="fd"
alias grep="rg"

# oh-my-posh
# eval "$(oh-my-posh init zsh --config ~/.config/oh-my-posh/config.toml)"

# starship
eval "$(starship init zsh)"

# Initialize zsh-vi-mode instantly on shell start
ZVM_INIT_MODE=sourcing

# zsh-vi-mode config
ZVM_INIT_MODE=sourcing
ZVM_LAZY_KEYBINDINGS=false
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
zvm_after_init_commands+=('eval "$(fzf --zsh)"')
