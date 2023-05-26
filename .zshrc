# PS4=$'\\\011%D{%s%6.}\011%x\011%I\011%N\011%e\011'
# exec 3>&2 2>/tmp/zshstart.$$.log
# setopt xtrace prompt_subst

autoload -U +X bashcompinit && bashcompinit
autoload -U +X compinit && compinit

####################  alias  #################### 
alias py=python
alias nvi=nvim
alias ll='ls -l'
alias lla='ll -a'
alias lsa='ls -a'
alias ..='cd ..'
alias cdf='cd $(find * -type d | fzf)'
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias ga='git add'
alias gcmsg='git commit -m'
alias ~='cd ~'

####################  variables  ####################

export EDITOR="nvim"
export VCPKG_ROOT="/Users/syh/vcpkg"
export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890
# LLVM path
# export PS1="%n@%m %1~ %#"
# export PS1="%n@%m | 中华有为  | 你说的对，但是我玩原神🤣👉 ｜ 锐刻五代 - 维新派 
# %~: "
export PS1="╭─%n@%m | HUAWEI 
╰─%B%(!.#.$)%b %~ "

export NVM_DIR="$HOME/.nvm"

####################  PATH  ####################

PATH="/opt/homebrew/opt/llvm/bin:$PATH"
PATH="/Users/syh/.ghcup/bin:$PATH"

####################  auto completions  ####################

if type brew &>/dev/null; then
FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# auto suggestion plugin
source /opt/homebrew/Cellar/zsh-autosuggestions/0.7.0/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# command syntax highlighting check plugin
source /opt/homebrew/Cellar/zsh-syntax-highlighting/0.7.1/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# vcpkg completion
source /Users/syh/vcpkg/scripts/vcpkg_completion.zsh
# fzf instead zsh default completion
source ~/somewhere/fzf-tab.plugin.zsh
# haskell-ghc env
source ~/.ghcup/env
# fzf integrate
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

####################  key bindings  ####################

bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

####################  start up  ####################

# unsetopt xtrace
# exec 2>&3 3>&-

autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
	setopt prompt_subst
	RPROMPT=\$vcs_info_msg_0_
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'
