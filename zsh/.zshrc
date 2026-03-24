# ─── PATH ─────────────────────────────────────────────────────────────────────
export PATH="$PATH:/Users/nvc/.local/bin"

# ─── HISTORY ──────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=20000
SAVEHIST=100000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt CORRECT

# ─── COMPLETION ───────────────────────────────────────────────────────────────
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# ─── NAVIGATION ───────────────────────────────────────────────────────────────
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# ─── TOOLS ────────────────────────────────────────────────────────────────────
eval "$(zoxide init zsh)"

# ─── PLUGINS (auto-clone if missing) ──────────────────────────────────────────
ZSH_PLUGINS_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh/plugins"

_zsh_plugin_load() {
  local repo=$1 name=${1##*/}
  local dir="$ZSH_PLUGINS_DIR/$name"
  [[ -d $dir ]] || git clone --depth=1 "https://github.com/$repo" "$dir"
}

_zsh_plugin_load zsh-users/zsh-autosuggestions
_zsh_plugin_load zsh-users/zsh-syntax-highlighting

# ─── ALIASES ──────────────────────────────────────────────────────────────────
alias ls="eza --color=always --git --icons=always"
alias ll="eza -la --color=always --git --icons=always"
alias cat="bat"
alias find="fd"
alias grep="rg"
alias v="nvim"
alias sc="source ~/.zshrc"
alias zsh-plugin-update='for d in "$ZSH_PLUGINS_DIR"/*/; do git -C "$d" pull; done'

# ─── ZSH-VI-MODE ──────────────────────────────────────────────────────────────
ZVM_INIT_MODE=sourcing
ZVM_LAZY_KEYBINDINGS=false
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# everything that hooks into ZLE must live here — zvm resets widgets on init
zvm_after_init() {
  eval "$(fzf --zsh)"
  eval "$(starship init zsh)"
  source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh  # must be last
}
