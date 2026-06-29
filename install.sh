#!/usr/bin/env bash
set -o pipefail

# --- Config ---
DOTFILES_DIR="$HOME/.df"
DOTFILES_REPO="git@github.com:adursh/dotfiles.git"
STOW_TARGET="$HOME"

MACOS_PACKAGES=(
  aerospace btop ghostty hammerspoon kanata karabiner
  mpv nvim oh-my-posh scripts sketchybar skhd sleepwatcher
  starship tmux yabai yazi zsh
)

LINUX_PACKAGES=(
  alacritty bash bin btop electron-flags gtk-3.0 gtk-4.0
  hypr keyd kitty nvim OCR4Linux profile rclone starship
  swaync swappy systemd-user tmux waybar wofi yazi zsh
)

SHARED_PACKAGES=(btop nvim starship tmux yazi zsh)

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# --- Logging ---
info()  { echo -e "${GREEN}[✓]${NC} $*"; }
warn()  { echo -e "${YELLOW}[!]${NC} $*"; }
error() { echo -e "${RED}[✗]${NC} $*" >&2; }
step()  { echo -e "\n${BLUE}▶${NC} $*"; }

# --- Platform Detection ---
detect_platform() {
  case "$(uname -s)" in
    Darwin) PLATFORM="macos" ;;
    Linux)  PLATFORM="linux" ;;
    *)      error "Unsupported OS: $(uname -s)"; exit 1 ;;
  esac
}

# --- Sudo Keep-Alive ---
sudo_keepalive() {
  if [[ "$PLATFORM" == "macos" ]]; then
    sudo -v || { error "Need sudo access"; exit 1; }
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  fi
}

# --- Homebrew ---
install_homebrew() {
  step "Homebrew"
  if command -v brew &>/dev/null; then
    info "Already installed"
  else
    info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
      || { error "Homebrew install failed"; exit 1; }
  fi

  # Ensure brew is in PATH for this session
  if [[ "$PLATFORM" == "macos" ]]; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" 2>/dev/null
  fi
}

# --- Clone Dotfiles ---
clone_dotfiles() {
  step "Dotfiles repo"
  if [[ -d "$DOTFILES_DIR/.git" ]]; then
    info "Already cloned at $DOTFILES_DIR"
    cd "$DOTFILES_DIR" && git pull --ff-only 2>/dev/null || true
  else
    info "Cloning dotfiles..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR" \
      || { error "Failed to clone dotfiles"; exit 1; }
  fi
}

# --- Brew Bundle ---
install_packages() {
  step "Brew packages"
  if [[ ! -f "$DOTFILES_DIR/Brewfile" ]]; then
    warn "No Brewfile found, skipping"
    return
  fi
  brew update || warn "brew update failed"
  brew bundle --file="$DOTFILES_DIR/Brewfile" \
    || warn "Some packages failed to install (non-fatal)"
  info "Brew bundle complete"
}

# --- Python Dependencies ---
install_python_deps() {
  step "Python dependencies"
  local venv_dir="$HOME/.local/share/dotfiles-venv"

  if [[ -d "$venv_dir" ]] && "$venv_dir/bin/python3" -c "import psutil" 2>/dev/null; then
    info "Python venv already set up"
    return
  fi

  info "Creating venv at $venv_dir"
  python3 -m venv "$venv_dir" || { error "Failed to create venv"; return 1; }
  "$venv_dir/bin/pip" install --quiet psutil || { error "Failed to install psutil"; return 1; }
  info "psutil installed in venv"
}

# --- Stow Packages ---
stow_packages() {
  step "Stowing packages"
  local packages=()

  if [[ "$PLATFORM" == "macos" ]]; then
    packages=("${MACOS_PACKAGES[@]}")
  else
    packages=("${LINUX_PACKAGES[@]}")
  fi

  local failed=0
  for pkg in "${packages[@]}"; do
    if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
      warn "Package '$pkg' not found, skipping"
      continue
    fi
    if stow --dir="$DOTFILES_DIR" --target="$STOW_TARGET" --restow --no-folding "$pkg" 2>/dev/null; then
      info "Stowed: $pkg"
    else
      # Retry without --no-folding for packages that need directory symlinks
      if stow --dir="$DOTFILES_DIR" --target="$STOW_TARGET" --restow "$pkg" 2>/dev/null; then
        info "Stowed: $pkg (folded)"
      else
        error "Failed to stow: $pkg"
        ((failed++))
      fi
    fi
  done

  [[ $failed -gt 0 ]] && warn "$failed package(s) failed to stow"
}

# --- Post-Install (macOS-specific) ---
post_install_macos() {
  step "Post-install (macOS)"

  # Update network_speed.py to use venv python
  local net_script="$DOTFILES_DIR/sketchybar/.config/sketchybar/plugins/network_speed.py"
  local venv_python="$HOME/.local/share/dotfiles-venv/bin/python3"
  if [[ -f "$net_script" ]] && [[ -f "$venv_python" ]]; then
    if head -1 "$net_script" | grep -q "#!/usr/bin/env python3"; then
      sed -i '' "1s|.*|#!$venv_python|" "$net_script"
      info "Updated network_speed.py shebang to use venv python"
    fi
  fi

  # Set default shell to brew zsh
  local brew_zsh
  brew_zsh="$(brew --prefix)/bin/zsh"
  if [[ -x "$brew_zsh" ]] && ! grep -q "$brew_zsh" /etc/shells 2>/dev/null; then
    echo "$brew_zsh" | sudo tee -a /etc/shells >/dev/null
    chsh -s "$brew_zsh" 2>/dev/null && info "Default shell set to $brew_zsh"
  fi

  # Start services
  brew services start sleepwatcher 2>/dev/null && info "sleepwatcher service started"

  info "macOS post-install done"
}

# --- Main ---
main() {
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${BLUE}  Dotfiles Install${NC}"
  echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

  detect_platform
  info "Platform: $PLATFORM"

  sudo_keepalive
  install_homebrew
  clone_dotfiles
  install_packages
  install_python_deps
  stow_packages

  if [[ "$PLATFORM" == "macos" ]]; then
    post_install_macos
  fi

  echo -e "\n${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
  echo -e "${GREEN}  Done! Restart your terminal.${NC}"
  echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

main "$@"
