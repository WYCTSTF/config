# 检查是否有未读邮件
set mail_file /var/mail/(whoami)

if test -f $mail_file
    set unread_count (grep -c '^From ' $mail_file)
    if test $unread_count -gt 0
        echo "你有 $unread_count 封未读邮件！使用 'mail' 命令查看。"
    end
end

function fish_prompt -d "Ah?"
printf '╭─%s@%s
╰─%s%s%s: ' 'wcb-dad ' " HUAWEI Matepad Air " (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
  # %s%s: ' 'wcb-dad' (hostname|cut -d . -f 1) (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

alias cls='clear'
alias vim=nvim
alias pbcopy='wl-copy'
alias pbpaste='wl-paste'
alias avim='NVIM_APPNAME=AstroNvim nvim'
alias lvim='NVIM_APPNAME=lazyVim nvim'
alias kvim='NVIM_APPNAME=kickstartNvim nvim'
alias nfz='nvim $(fzf)'
alias cdf='cd $(find * -type d | fzf)'
alias gst='git status'
alias gl='git pull'
alias gp='git push'
alias ga='git add'
alias gcmsg='git commit -m'
alias nproc="sysctl -n hw.logicalcpu"
alias lg='lazygit'
alias rm='trash'
alias cf='cf-tool'
alias leetcode='neovide leetcode.nvim'
alias postman='/home/syh/postman/Postman/Postman'

# export TERM="xterm-256color"
export SHELL="fish"
export EDITOR="nvim"
export VCPKG_ROOT="/Users/syh/vcpkg"

# PATH settings
set PATH /home/syh/llvm18.1.8/bin  $PATH

set -x PATH $PATH /usr/local/go/bin
set -x GOPATH $HOME/go_projects
set -x PATH $PATH $GOPATH/bin
set -x PATH $PATH /usr/local/texlive/2024/bin/aarch64-linux

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f ~/miniconda3/bin/conda
  eval ~/miniconda3/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<
