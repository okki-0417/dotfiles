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
| `iterm2/` | iTerm2 の設定フォルダとして指定（リンクではない。下記参照） |

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

`iterm2/com.googlecode.iterm2.plist` に設定を保存している。iTerm2 側で次のように指定する。

1. Settings > General > Settings を開く
2. 「Load settings from a custom folder or URL」にチェックし、`<このリポジトリ>/iterm2` を選ぶ
3. 「Save changes」を `Automatically` にする

以降、iTerm2 の設定を変えるとこのファイルが書き換わるので、必要に応じてコミットする。

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
