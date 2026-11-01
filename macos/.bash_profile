export CLICOLOR=1

export LSCOLORS=ExGxFxdaCxDaDahbadeche

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


export PATH=/opt/homebrew/bin:/opt/homebrew/opt/llvm/bin:/bin:/sbin:/usr/sbin:/usr/bin:/usr/local/bin:/opt/homebrew/opt/tomcat/libexec/bin:/opt/homebrew/opt/vim/bin:/usr/local/mysql/support-files:/Users/syh/cnblog/node_modules/.bin:/Users/syh/Downloads:/usr/local/mysql/bin:/Users/syh/cabal/bin:/Users/syh/.ghcup/bin:/usr/local/texlive/2021/bin/universal-darwin/

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

