# dotfiles

my dotfiles (macOS)

## 構成

| リポジトリ内 | リンク先 |
| --- | --- |
| `zsh/.zshrc` | `~/.zshrc` |
| `git/.gitconfig` | `~/.gitconfig`（名前・メールは `~/.gitconfig.local` に書く） |
| `nvim/` | `~/.config/nvim` |
| `vim/.vimrc` | `~/.vimrc` |
| `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |
| `vscode/keybindings.json` | `~/Library/Application Support/Code/User/keybindings.json` |
| `vscode/snippets/` | `~/Library/Application Support/Code/User/snippets` |
| `iterm2/profile.json` | `~/Library/Application Support/iTerm2/DynamicProfiles/dotfiles.json` |

### zsh

`zsh/.zshrc` は読み込み順を決めるだけで、中身は `zsh/rc/` に役割ごとに分かれています。

| ファイル | 内容 |
| --- | --- |
| `path.zsh` | PATH |
| `tools.zsh` | nodenv / rbenv / direnv などの初期化 |
| `prompt.zsh` | プロンプト |
| `completion.zsh` | 補完 |
| `aliases.zsh` | エイリアス |
| `functions.zsh` | 関数 |
| `plugins.zsh` | fzf / zsh-autosuggestions / zsh-syntax-highlighting など（`brew install fzf zsh-autosuggestions zsh-syntax-highlighting`） |

### Neovim

メインのエディタ。VSCode の設定・ショートカットを移植してある。
構成・操作方法・VSCode との対応表は [nvim/README.md](nvim/README.md)。
`vim/.vimrc` はプラグインなしの素の Vim 用の最低限の設定。

### iTerm2

| ファイル | 内容 |
| --- | --- |
| `iterm2/profile.json` | プロファイル（フォント・配色・カーソル・キー割り当てなど）。全項目を書き出してあるので、ここを直接編集する |
| `iterm2/defaults.sh` | プロファイル以外の全体設定（スクロールバー非表示など）を `defaults write` で適用するスクリプト |

- `profile.json` は iTerm2 の Dynamic Profile として読み込まれ、保存すると即座に反映される（GUI で変更しても保存されないので、変更は JSON で行う）
- 色は `Red / Green / Blue Component`（0〜1）で書く。`(Dark)` / `(Light)` 付きはダーク / ライトモード別の色
- 初回は iTerm2 を終了した状態で（別のターミナルから）`./iterm2/defaults.sh` を実行し、iTerm2 を起動する（既定のプロファイルも `Dotfiles` になる）。起動中に実行すると iTerm2 の終了時に上書きされるため、スクリプトは起動中なら中断する

## セットアップ

```sh
git clone https://github.com/okki-0417/dotfiles.git ~/src/github.com/mumumu/dotfiles
cd ~/src/github.com/mumumu/dotfiles

./install.sh   # シンボリックリンクを作成
```

- 何度実行しても安全です（既存のリンクは張り直されるだけ）
- リンク先に実ファイルがある場合は `<file>.backup.<日時>` に退避してからリンクします

## 新しい dotfile を追加するとき

1. ファイルをリポジトリに移動する（例: `mv ~/.gitconfig git/.gitconfig`）
2. `install.sh` の末尾に `link git/.gitconfig "$HOME/.gitconfig"` を追加
3. `./install.sh` を実行
