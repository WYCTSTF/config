set fish_greeting '都什么年代，还在用传统shell'

function fish_title
	echo "我测你码 | "(prompt_pwd)
end

alias py=python

export TERM="xterm-256color"
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
set PATH /Users/syh/cnblog/node_modules/.bin			    $PATH
set PATH /opt/homebrew/Cellar                         $PATH

set NOCLOBBER 1

# Proxy switcher
function proxy
  if test "$argv[1]" = "on"
    if test "$argv[2]" = ""
      echo "No port provided"
      return 2
    end
    # proxy offered by local shadowsocks
    export http_proxy="http://127.0.0.1:$argv[2]"
    export https_proxy="http://127.0.0.1:$argv[2]"
  else if test "$argv[1]" = "off"
    set -e http_proxy
    set -e https_proxy
  else if test "$argv[1]" != ""
    echo "Usage: 
        proxy          - view current proxy
        proxy on PORT  - turn on proxy at localhost:PORT
        proxy off      - turn off proxy"
    return 1
  end
  echo "Current: http_proxy=$http_proxy https_proxy=$https_proxy"
end

# conda configuration
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
    eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<
