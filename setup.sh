#!/usr/bin/env zsh

ZSHRC_URL="https://raw.githubusercontent.com/daniil-tokarchuk/config/mac-intel/.zshrc"
# Declare CONFIG with its value from zsh config.
eval "$(curl "${ZSHRC_URL}" --fail --silent --show-error --location 2>&1 | \
	grep CONFIG=)"

# Setup SSH.
ED="${HOME}/.ssh/ed"
ssh-keygen -qt ed25519 -C "daniil.v.tokarchuk@gmail.com" -f "${ED}" -P ""
ssh-add -q --apple-use-keychain "${ED}"
ssh-keyscan github.com >> "${HOME}/.ssh/known_hosts"
pbcopy < "${ED}.pub"
read -sk $'?paste into github.com/account/ssh\n'

# Install Homebrew it installs xcode dev tools and git.
BREW_URL="https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh"
/bin/bash -c "$(curl -fsSL "${BREW_URL}")"

# Clone and setup configs.
rm -rf "${CONFIG}"
mkdir -p "${CONFIG}"
git clone git@github.com:daniil-tokarchuk/config.git "${CONFIG}"
ln -sf "${CONFIG}/.zshrc" "${HOME}/.zshrc"
ln -sf "${CONFIG}/.gitconfig" "${HOME}/.gitconfig"
ln -sf "${CONFIG}/.sshconfig" "${HOME}/.ssh/config"
CONFIG_NVIM="${HOME}/.config/nvim"
mkdir -p "${CONFIG_NVIM}"
ln -sf "${CONFIG}/nvim.lua" "${CONFIG_NVIM}/init.lua"

# Use brew --prefix to bootstrap PATH & completions
HOMEBREW_PREFIX="/usr/local"
echo "eval \"\$(${HOMEBREW_PREFIX}/bin/brew shellenv)\"" >> ~/.zprofile
eval "$(${HOMEBREW_PREFIX}/bin/brew shellenv)"
export PATH="${HOMEBREW_PREFIX}/bin:${PATH}"
chmod -R go-w "${HOMEBREW_PREFIX}/share/zsh"
FPATH="${HOMEBREW_PREFIX}/share/zsh-completions:${FPATH}"

autoload -Uz compinit
compinit
rm -f ~/.zcompdump
compaudit | xargs chmod g-w

BREW_FORMULAE=(
  # n
  neovim
  ripgrep
  zsh-completions
)
BREW_CASKS=(
  iterm2
  # intellij-idea
  google-chrome
  # bitwarden
  notion
  grammarly-desktop
  # postman
  # docker
  telegram
  # discord
  # slack
  spotify
  tunnelbear
  vlc
  gimp
  qbittorrent
  font-ubuntu-mono-nerd-font
)

brew update
brew upgrade
brew install "${BREW_FORMULAE[@]}"
brew install --cask "${BREW_CASKS[@]}"
brew completions link
brew autoremove
brew cleanup --prune=all

defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write -g com.apple.trackpad.scaling -float 3.0
defaults write NSGlobalDomain NSUserKeyEquivalents -dict-add "Zoom" "@\$F"
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock wvous-br-corner -int 0
