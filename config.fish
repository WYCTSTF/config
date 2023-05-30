function fish_prompt -d "Write out the prompt"

printf '╭─%s@%s | HUAWEI 
╰─%s%s%s: ' (whoami) (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)

end

# function fish_title
# 	echo "玩原神玩的 | "(prompt_pwd)
# end

alias py=python
alias nvi=nvim
alias lla='ll -a'
alias lsa='ls -a'
alias cdf='cd $(find * -type d | fzf)'
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias ga='git add'
alias gcmsg='git commit -m'

# export TERM="xterm-256color"
export SHELL="fish"
export EDITOR="nvim"
export VCPKG_ROOT="/Users/syh/vcpkg"

# nvm settings
source ~/.config/fish/nvm-wrapper/nvm.fish

# PATH settings
set PATH /opt/homebrew/bin /opt/homebrew/opt/llvm/bin $PATH
set PATH /opt/homebrew/sbin														$PATH
set PATH /opt/homebrew/opt/gawk/libexec/gnubin        $PATH
set PATH /usr/local/mysql/support-files               $PATH
set PATH /Users/syh/.ghcup/bin                        $PATH
set PATH /usr/local/texlive/2021/bin/universal-darwin $PATH
set PATH /opt/homebrew/Cellar                         $PATH
