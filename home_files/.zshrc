autoload -U promptinit && promptinit
#promptinit
autoload -U colors && colors
bindkey -v

setopt prompt_subst

alias open='xdg-open'
alias vim='nvim'
# Load git info
autoload -Uz vcs_info

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
NEWLINE=$'\n'
PROMPT='%{$fg_bold[black]%}${vcs_info_msg_0_}%{$reset_color%} %{$fg_bold[black]%}%~%{$reset_color%}${NEWLINE} %{$fg_bold[black]%}λ%{$reset_color%} '
zstyle ':vcs_info:git:*' formats '[%b]'

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh

[ -f "/Users/marccoquand/.ghcup/env" ] && source "/Users/marccoquand/.ghcup/env" # ghcup-env

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
