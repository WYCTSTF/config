#!/usr/bin/env bash
# Link or copy this repo's platform configs into $HOME.
# Default is dry-run. Add --apply to actually change files.
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
apply=0
mode=link
platform=""

usage() {
  cat <<'USAGE'
Usage: scripts/bootstrap.sh [--apply] [--dry-run] [--link|--copy] [--platform macos|wsl]

  --apply          Actually write files. Default only prints what would happen.
  --dry-run        Print actions only (default).
  --link           Symlink configs (default).
  --copy           Copy configs instead of linking.
  --platform ...   Override auto-detection.

Existing files are moved to <target>.bak-YYYYMMDD-HHMMSS before replacing.
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --apply) apply=1 ;;
    --dry-run) apply=0 ;;
    --link) mode=link ;;
    --copy) mode=copy ;;
    --platform)
      shift
      platform=${1:-}
      ;;
    -h|--help) usage; exit 0 ;;
    *) echo "unknown argument: $1" >&2; usage; exit 2 ;;
  esac
  shift
done

if [ -z "$platform" ]; then
  case "$(uname -s)" in
    Darwin) platform=macos ;;
    Linux) platform=wsl ;;
    *) echo "unsupported OS; use --platform macos|wsl" >&2; exit 1 ;;
  esac
fi

case "$platform" in
  macos|wsl) ;;
  *) echo "invalid platform: $platform" >&2; exit 1 ;;
esac

stamp=$(date +%Y%m%d-%H%M%S)
actions=0

install_one() {
  local src=$1
  local target=$2
  local dst="$HOME/$target"

  if [ ! -e "$src" ]; then
    echo "skip (missing source): $src" >&2
    return
  fi

  actions=$((actions + 1))
  if [ "$apply" -eq 0 ]; then
    printf 'would %-4s %s -> %s\n' "$mode" "$src" "$dst"
    return
  fi

  mkdir -p "$(dirname "$dst")"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
      echo "already linked: $dst"
      return
    fi
    local bak="$dst.bak-$stamp"
    mv "$dst" "$bak"
    echo "backup: $bak"
  fi

  if [ "$mode" = link ]; then
    ln -s "$src" "$dst"
    echo "linked: $dst -> $src"
  else
    cp "$src" "$dst"
    echo "copied: $src -> $dst"
  fi
}

# Shared configs
install_one "$repo_dir/shared/.vimrc" ".vimrc"

if [ "$platform" = macos ]; then
  install_one "$repo_dir/macos/.bash_profile" ".bash_profile"
  install_one "$repo_dir/macos/.zshrc" ".zshrc"
  install_one "$repo_dir/macos/alacritty.toml" ".config/alacritty/alacritty.toml"
else
  install_one "$repo_dir/wsl/.bashrc" ".bashrc"
  install_one "$repo_dir/wsl/.tmux.conf" ".tmux.conf"
  install_one "$repo_dir/wsl/config.fish" ".config/fish/config.fish"
  install_one "$repo_dir/shared/pi/agent/extensions/wt-tabs.ts" ".pi/agent/extensions/wt-tabs.ts"
fi

echo
if [ "$apply" -eq 0 ]; then
  echo "dry-run: $actions target(s). Re-run with --apply to write."
else
  echo "done: $actions target(s) processed."
  echo "reload: source ~/.bashrc; tmux source-file ~/.tmux.conf; exec fish"
  echo "pi: run /reload in an existing session, or start a new one."
fi
