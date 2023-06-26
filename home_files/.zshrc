autoload -U promptinit && promptinit
#promptinit
autoload -U colors && colors

# Enable vim mode
#bindkey -v

setopt prompt_subst
alias vim='nvim'
# Load git info
autoload -Uz vcs_info

precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
NEWLINE=$'\n'
PROMPT='%{$fg_bold[blue]%}%~%{$reset_color%}%{$fg_bold[black]%}${vcs_info_msg_0_}%{$reset_color%}${NEWLINE}%{$fg_bold[black]%}𝝺%{$reset_color%} '

zstyle ':vcs_info:git:*' formats '  %b'

export NVM_DIR=~/.nvm
source $(brew --prefix nvm)/nvm.sh
export PATH="/Users/marccoquand/.nvm/versions/node/v14.20.0/bin/node:~/.local/bin:~/.config/emacs/bin:$PATH"
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@3/lib/pkgconfig"

[ -f "/Users/marccoquand/.ghcup/env" ] && source "/Users/marccoquand/.ghcup/env" 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/.credentials

# opam configuration
[[ ! -r /Users/marccoquand/.opam/opam-init/init.zsh ]] || source /Users/marccoquand/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null
