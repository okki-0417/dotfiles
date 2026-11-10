#!/usr/bin/env bash
# dotfiles のシンボリックリンクを張る（何度実行してもOK）
set -eu

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
VSCODE="$HOME/Library/Application Support/Code/User"

# link <リポジトリ内のパス> <リンクを置く場所>
link() {
  local src="$DOTFILES/$1"
  local dest="$2"

  # 実ファイルがあれば消さずに退避（シンボリックリンクなら上書きでOK）
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "$dest.backup.$(date +%Y%m%d%H%M%S)"
    echo "backup: $dest"
  fi

  mkdir -p "$(dirname "$dest")"
  ln -sfn "$src" "$dest"
  echo "linked: $dest"
}

link zsh/.zshrc              "$HOME/.zshrc"
link vim/.vimrc              "$HOME/.vimrc"
link vscode/settings.json    "$VSCODE/settings.json"
link vscode/keybindings.json "$VSCODE/keybindings.json"
link vscode/snippets         "$VSCODE/snippets"
