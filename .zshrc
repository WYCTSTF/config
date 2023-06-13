# PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
# exec 3>&2 2>/tmp/zshstart.$$.log
# setopt xtrace prompt_subst

# autoload -U +X bashcompinit && bashcompinit
# autoload -U +X compinit && compinit

alias py=python
alias nvi=nvim
alias ll='ls -l'
alias lla='ll -a'
alias lsa='ls -a'
alias cdf='cd $(find * -type d | fzf)'
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias ga='git add'
alias gcmsg='git commit -m'

export EDITOR="nvim"
export VCPKG_ROOT="/Users/syh/vcpkg"
export PS1="╭─%n@%m | HUAWEI 
╰─%B%(!.#.$)%b %~ "
export NVM_DIR="$HOME/.nvm"

PATH="/opt/homebrew/opt/llvm/bin:$PATH"
PATH="/Users/syh/.ghcup/bin:$PATH"

if type brew &>/dev/null; then
FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

source /opt/homebrew/Cellar/zsh-autosuggestions/0.7.0/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/Cellar/zsh-syntax-highlighting/0.7.1/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /Users/syh/vcpkg/scripts/vcpkg_completion.zsh
source ~/somewhere/fzf-tab.plugin.zsh
source ~/.ghcup/env
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# unsetopt xtrace
# exec 2>&3 3>&-

# git env prompt
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
	setopt prompt_subst
	RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'
