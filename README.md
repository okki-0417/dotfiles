# dotfiles

my dotfiles (macOS)

## 構成

| リポジトリ内 | リンク先 |
| --- | --- |
| `zsh/.zshrc` | `~/.zshrc` |
| `vim/.vimrc` | `~/.vimrc` |
| `brew/Brewfile` | `~/.Brewfile` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |
| `vscode/snippets/` | `~/Library/Application Support/Code/User/snippets` |

## セットアップ

```sh
git clone https://github.com/okki-0417/dotfiles.git ~/src/github.com/mumumu/dotfiles
cd ~/src/github.com/mumumu/dotfiles

./install.sh   # シンボリックリンクを作成
```

- 何度実行しても安全です（既存のリンクは張り直されるだけ）
- リンク先に実ファイルがある場合は `<file>.backup.<日時>` に退避してからリンクします

### Homebrew

```sh
brew bundle --global          # ~/.Brewfile からインストール
brew bundle dump --global -f  # 現在の状態を Brewfile に書き出す
```

## 新しい dotfile を追加するとき

1. ファイルをリポジトリに移動する（例: `mv ~/.gitconfig git/.gitconfig`）
2. `install.sh` の末尾に `link git/.gitconfig "$HOME/.gitconfig"` を追加
3. `./install.sh` を実行
