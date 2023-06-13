function fish_prompt -d "Ah?"

printf '╭─%s@%s | HUAWEI 
╰─%s%s%s: ' (whoami) (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)

end

alias py=python
alias nvi=nvim
alias hexo="npx hexo"
alias nfz='nvim $(fzf)'
alias cdf='cd $(find * -type d | fzf)'
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias ga='git add'
alias gcmsg='git commit -m'
alias nproc="sysctl -n hw.logicalcpu"

# export TERM="xterm-256color"
export SHELL="fish"
export EDITOR="nvim"
export VCPKG_ROOT="/Users/syh/vcpkg"

# nvm settings
source ~/.config/fish/nvm-wrapper/nvm.fish

# PATH settings
set PATH /usr/local/bin                               $PATH
set PATH /opt/homebrew/bin /opt/homebrew/opt/llvm/bin $PATH
set PATH /opt/homebrew/sbin														$PATH
set PATH /opt/homebrew/opt/gawk/libexec/gnubin        $PATH
set PATH /usr/local/mysql/support-files               $PATH
set PATH /Users/syh/.ghcup/bin                        $PATH
set PATH /usr/local/texlive/2021/bin/universal-darwin $PATH
set PATH /opt/homebrew/Cellar                         $PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
    eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

