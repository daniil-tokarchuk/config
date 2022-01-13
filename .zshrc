CONFIG="${HOME}/Projects/config"
PROJECTS="${HOME}/Projects"
FPATH="/opt/homebrew/share/zsh-completions:${FPATH}"
N_PREFIX="${HOME}/.n"; PATH+=":${N_PREFIX}/bin"
EDITOR="v"
HISTSIZE=1000000

alias cd.="cd ${CONFIG}"
alias cdp="cd ${PROJECTS}"
alias cdf="cd ${PROJECTS}/dom-frontend"
alias cdb="cd ${PROJECTS}/dom-backend"
alias cdt="cd ${PROJECTS}/dom-tracking-domains"
# Dynamically create aliases for navigating up directory levels
for i in {1..5}; do
  alias $(printf '.%.s' {0..$i})="cd $(printf '../%.s' {1..$i})"
done

alias g="git"
alias v="nvim"
alias q="exit"
alias l="ls -AlFh"
alias o="open -a 'IntelliJ IDEA' ."
alias uz="v ${HOME}/.zshrc && . ${HOME}/.zshrc"
alias uv="v ${HOME}/.config/nvim/init.lua"
alias ug="v ${HOME}/.gitconfig"
alias us="v ${CONFIG}/setup.sh"
alias u="brew update && brew upgrade --greedy && brew autoremove && brew cleanup --prune=all"

alias d="docker"
alias ds="d ps -a --format 'table {{.Names}}\t{{.Image}}\t{{.Status}}'"
alias dr="d restart"
alias dv="d volume ls"
alias dsp="d system prune"

alias dcu="d compose -f compose.yaml up -d --build --pull always"
alias dcd="d compose down"
alias dcs="d compose ps -a --format 'table {{.Name}}\t{{.Image}}\t{{.Status}}'"

alias cs="ssh root@65.108.196.190"

setopt NO_BEEP
setopt globdots
zmodload zsh/complist
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
zstyle ':completion:*' menu select
autoload -Uz compinit; compinit -C

PAM_TID="pam_tid.so"
PAM_CONFIG="/etc/pam.d/sudo"
if ! grep -q "${PAM_TID}" "${PAM_CONFIG}"; then
	# Enable Touch ID for sudo.
	sudo sed -i "" $'2a\\\nauth       sufficient     '"${PAM_TID}"$'\n' \
		"${PAM_CONFIG}"
fi

PROMPT='%~ > '
bindkey -v; KEYTIMEOUT=1
zle-line-init() { echo -n '\e[6 q'}; zle -N zle-line-init 
zle-keymap-select() { echo -n "\e[$([[ $KEYMAP == main ]] && echo 6 || echo 2) q" }; zle -N zle-keymap-select
git-status-cli() {
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    RPROMPT='' 
  return
  fi
  local git_info=$(git status -sb && git stash list -n 1)
  local branch_info=${git_info%%$'\n'*}
  local file_statuses=$(echo $git_info | awk '{print $1}')
  [[ $branch_info =~ [[:space:]]([^.]*) ]] && RPROMPT="λ:$match[1]"
  [[ $branch_info =~ behind   ]] && RPROMPT+=' <'
  [[ $branch_info =~ ahead    ]] && RPROMPT+=' >'
  [[ $file_statuses =~ A      ]] && RPROMPT+=' a'
  [[ $file_statuses =~ [MT]   ]] && RPROMPT+=' m'
  [[ $file_statuses =~ D      ]] && RPROMPT+=' d'
  [[ $file_statuses =~ R      ]] && RPROMPT+=' r'
  [[ $file_statuses =~ UU     ]] && RPROMPT+=' ='
  [[ $file_statuses =~ \\?\\? ]] && RPROMPT+=' u'
  [[ $file_statuses =~ stash  ]] && RPROMPT+=' s'
}; autoload add-zsh-hook; add-zsh-hook precmd git-status-cli
