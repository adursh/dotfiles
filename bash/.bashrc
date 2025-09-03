#
# ~/.bashrc
#


# ---- Starship ----
eval "$(starship init bash)"


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '



# ---- General Aliases ----

alias ll='ls -alF'


# ---- Yazi Configuration ----
export EDITOR="nvim"


# ---- FZF -----

# Set up fzf key bindings and fuzzy completion
eval "$(fzf --bash)"

# --- setup fzf theme (Catppuccin-inspired) ---
fg="#CDD6F4"
bg="#1E1E2E"
bg_highlight="#313244"
hl="#F38BA8"
hl_plus="#F38BA8"
header="#F38BA8"
info="#CBA6F7"
pointer="#F5E0DC"
marker="#B4BEFE"
prompt="#CBA6F7"
selected_bg="#45475A"
border="#313244"
label="#CDD6F4"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#313244,label:#CDD6F4"

# -- Use fd for search instead of find with fzf --

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

# show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

# export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
# export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}


# ---- Thefuck ----

#thefuck alias
eval "$(thefuck --alias)"
eval "$(thefuck --alias fk)"


# ---- Zoxide (better cd) ----
eval "$(zoxide init bash)"
alias z='cd'


# ---- Eza (better ls) -----
alias ls="eza --icons=always"


# swaync reload 
alias sr="swaync-client -R -rs"


# edit hyprland
alias hypr="nvim ~/.config/hypr/hyprland.conf"
