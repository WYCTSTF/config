alias py=python
alias nvi=nvim
alias hexo='npx hexo'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export ZSH=$HOME/.oh-my-zsh
export EDITOR="nvim"
export VCPKG_ROOT="/Users/syh/vcpkg"

export https_proxy=http://127.0.0.1:7890 http_proxy=http://127.0.0.1:7890 all_proxy=socks5://127.0.0.1:7890

ZSH_THEME="bira"

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
)

# PATH
PATH="/opt/homebrew/opt/gawk/libexec/gnubin:$PATH"
PATH="/opt/homebrew/bin:/opt/homebrew/opt/llvm/bin:$PATH"
PATH="/opt/homebrew/sbin:$PATH"
PATH="/usr/local/mysql/support-files:$PATH"
PATH="/Users/syh/.ghcup/bin:$PATH"
PATH="/usr/local/texlive/2021/bin/universal-darwin:$PATH"
PATH="/opt/homebrew/Cellar:$PATH"

setopt NO_CLOBBER
unsetopt beep

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $ZSH/oh-my-zsh.sh
source ~/.ghcup/env
source /Users/syh/vcpkg/scripts/vcpkg_completion.zsh

autoload bashcompinit
bashcompinit

# brew autocompletion
if type brew &>/dev/null; then
	FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

	autoload -Uz compinit
	compinit
fi
