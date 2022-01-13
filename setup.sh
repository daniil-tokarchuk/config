#!/usr/bin/env zsh

ZSHRC_URL="https://raw.githubusercontent.com/daniil-tokarchuk/config/master/.zshrc"
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

# Install Homebrew.
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

# Homebrew setup.
export PATH="${PATH}:/opt/homebrew/bin"
chmod -R go-w '/usr/local/share/zsh'
FPATH="/usr/local/share/zsh-completions:${FPATH}"
autoload -Uz compinit
compinit
rm -f ~/.zcompdump
compaudit | xargs chmod g-w
BREW_FORMULAE=(
  neovim
  ripgrep
  zsh-completions
)
BREW_CASKS=(
  iterm2
  font-ubuntu-mono-nerd-font
  bitwarden
  google-chrome
  notion
  telegram
  grammarly-desktop
  spotify
  discord
  tunnelbear
  qbittorrent
)
brew update
brew upgrade
brew install "${BREW_FORMULAE[@]}"
brew install --cask "${BREW_CASKS[@]}"
brew completions link
brew autoremove
brew cleanup --prune=all
