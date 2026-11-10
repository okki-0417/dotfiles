#!/usr/bin/env bash
# dotfiles のシンボリックリンクを張るスクリプト
#
# 使い方:
#   ./install.sh            リンクを作成
#   ./install.sh --dry-run  何をするか表示のみ
#
# - 何度実行しても安全（既に正しいリンクがあればスキップ）
# - リンク先に実ファイルがある場合は <file>.backup.<日時> に退避してから張る
# - 別の場所を指すシンボリックリンクは張り替える

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
DRY_RUN=false
[[ "${1:-}" == "--dry-run" ]] && DRY_RUN=true

# "リポジトリ内のパス:リンクを置くパス"
LINKS=(
  "zsh/zshrc:$HOME/.zshrc"
  "vim/vimrc:$HOME/.vimrc"
  "brew/Brewfile:$HOME/.Brewfile"
  "vscode/settings.json:$VSCODE_USER_DIR/settings.json"
  "vscode/keybindings.json:$VSCODE_USER_DIR/keybindings.json"
  "vscode/snippets:$VSCODE_USER_DIR/snippets"
)

run() {
  if $DRY_RUN; then
    echo "  [dry-run] $*"
  else
    "$@"
  fi
}

link() {
  local src="$DOTFILES_DIR/$1"
  local dest="$2"

  if [[ ! -e "$src" ]]; then
    echo "skip   $1 (リポジトリに存在しません)"
    return
  fi

  if [[ -L "$dest" && "$(readlink "$dest")" == "$src" ]]; then
    echo "ok     $dest"
    return
  fi

  if [[ -L "$dest" ]]; then
    # 別の場所を指すリンク（リンク切れ含む）は中身を持たないので張り替える
    echo "relink $dest (was -> $(readlink "$dest"))"
    run rm "$dest"
  elif [[ -e "$dest" ]]; then
    local backup="$dest.backup.$(date +%Y%m%d%H%M%S)"
    echo "backup $dest -> $backup"
    run mv "$dest" "$backup"
  fi

  echo "link   $dest -> $src"
  run mkdir -p "$(dirname "$dest")"
  run ln -s "$src" "$dest"
}

for entry in "${LINKS[@]}"; do
  link "${entry%%:*}" "${entry#*:}"
done
