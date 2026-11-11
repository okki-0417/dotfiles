# Neovim

VSCode から移行するための Neovim 設定。`~/.config/nvim` にリンクされる。

## 構成（1ファイル = 1つの責務）

```
nvim/
├── init.lua                 読み込み順だけ
├── lua/config/
│   ├── options.lua          オプション（settings.json 相当）
│   ├── keymaps.lua          プラグインに依存しないキーマップ（keybindings.json 相当）
│   ├── option_key.lua       macOS の Option キー → 入力される文字の対応表
│   ├── autocmds.lua         自動保存 / 保存時の行末空白削除 など
│   └── lazy.lua             プラグインマネージャ lazy.nvim
├── lua/plugins/             プラグインの設定。各プラグインのキーマップもここの `keys` に書く
│   ├── colorscheme.lua      catppuccin + VSCode のピンク系カスタム色
│   ├── ui.lua               ステータスライン / バッファタブ / which-key / インデントガイド
│   ├── explorer.lua         ファイルツリー（neo-tree）
│   ├── finder.lua           ファイル検索・grep（telescope）
│   ├── lsp.lua              言語サーバー + LSP のキーマップ + 問題パネル
│   ├── completion.lua       補完とスニペット（blink.cmp）
│   ├── formatting.lua       保存時フォーマット（conform）
│   ├── treesitter.lua       ハイライト / 構文単位の選択
│   ├── git.lua              gitsigns / diffview / fugitive
│   ├── editing.lua          括弧補完 / 囲み / マルチカーソル / Emmet / ジャンプ / 置換
│   ├── ai.lua               GitHub Copilot
│   └── terminal.lua         統合ターミナル
├── lsp/<サーバー名>.lua      言語サーバーごとの設定（vtsls の import 設定など）
├── snippets/package.json    ../vscode/snippets/*.json を Neovim のファイルタイプに対応付け
└── lazy-lock.json           プラグインのバージョン固定（:Lazy update で更新してコミット）
```

- プラグインを足す → `lua/plugins/` に新しいファイルを作るか、責務の合うファイルに追記
- 言語サーバーを足す → `lua/plugins/lsp.lua` の `servers` に追加（設定が必要なら `lsp/<名前>.lua`）
- フォーマッタを足す → `lua/plugins/formatting.lua` の `formatters_by_ft`

## 初回セットアップ

1. `brew install neovim tree-sitter-cli`（Neovim 0.12 以上。tree-sitter-cli は構文ハイライトのパーサーのビルドに必要）
2. `./install.sh` → `nvim` を起動するとプラグインと言語サーバーが自動で入る（`:Lazy` / `:Mason` で確認）
3. **アイコン用フォント**:
   - Terminal.app: `brew install --cask font-meslo-lg-nerd-font` → `../terminal/apply.sh`（プロファイルのフォントが Meslo の Nerd Font 版になっている）
   - iTerm2: `brew install --cask font-symbols-only-nerd-font` → Profiles > Text で「Use a different font for non-ASCII text」にチェックし、Non-ASCII Font を `Symbols Nerd Font Mono` にする（`iterm2/profile.json` には設定済み）
4. `:Copilot auth` で GitHub Copilot にログイン
5. 操作に慣れるには `:Tutor`（Vim 標準のチュートリアル、30分ほど）

## Vim の基本（まずはこれだけ）

| やりたいこと | キー |
| --- | --- |
| 挿入モードへ / ノーマルモードへ戻る | `i`（カーソル前） `a`（後） `o`（下に行追加） / `Esc` |
| 移動 | `h j k l` / 単語 `w b e` / 行頭行末 `0 ^ $` / ファイル先頭末尾 `gg G` / 半ページ `Ctrl+d Ctrl+u` |
| 削除・変更・コピー | `d` `c` `y` + 移動（`dw` 単語削除, `ciw` 単語を書き換え, `yy` 行コピー, `dd` 行削除） / 貼り付け `p` |
| 括弧・引用符の中 | `ci"` `di(` `yi{`（`a` にすると括弧ごと） |
| 取り消し / やり直し / 繰り返し | `u` / `Ctrl+r` / `.` |
| 選択 | `v`（文字） `V`（行） `Ctrl+v`（矩形） |
| ファイル内検索 | `/単語` → `n` / `N`。カーソル下の単語は `*` |
| 置換 | `:%s/old/new/gc` |
| 戻る / 進む | `Ctrl+o` / `Ctrl+i` |

`Space` を押して待つと、使えるキーの一覧（which-key）が出る。

## VSCode からの対応表

`cmd` キーはターミナル上の Neovim に届かないので、`Space`（`<leader>`）始まりに置き換えている。
`Option` キーは iTerm2 の設定を変えずに使えるよう、Option+キーで入力される文字（`∆` など）に割り当てている（`lua/config/option_key.lua`）。

### 自分で設定していた keybindings.json

| VSCode | Neovim | 備考 |
| --- | --- | --- |
| `ctrl+h/j/k/l`（カーソル移動） | 挿入モードで `Ctrl+h/j/k/l` | ノーマルモードでは `h j k l` そのもの。`Ctrl+hjkl` はウィンドウ移動 |
| `ctrl+shift+hjkl`（選択しながら移動） | `v` で選択開始して `hjkl` | |
| `ctrl+cmd+j/k`（ファイル末尾 / 先頭） | `G` / `gg` | |
| `ctrl+cmd+l/h`（単語単位） | `e` / `b` | |
| `ctrl+4` / `ctrl+=`（行頭 / 行末） | `^` / `$` | |
| `ctrl+u` / `ctrl+d`（ページ移動） | `Ctrl+u` / `Ctrl+d` | Vim 標準と同じ |
| `ctrl+/`（コメント） | `Ctrl+/` または `gcc`（ビジュアルで `gc`） | |
| `ctrl+]` / `ctrl+[`（インデント） | `>>` / `<<`（ビジュアルで `>` `<`） | `Ctrl+[` は Esc と同じなので割り当て不可 |
| `alt+j/k`（行の移動） | `Option+j/k` | |
| `shift+alt+j/k`（行の複製） | `Option+Shift+j/k` | |
| `ctrl+enter`（定義へ） | `gd`（`Ctrl+Enter` も設定済み※） | |
| `ctrl+shift+enter`（戻る） | `Ctrl+o` | |
| `ctrl+m` / `ctrl+,`（前 / 次のタブ） | `Shift+h` / `Shift+l` | `Ctrl+m` は端末では Enter と同じ |
| `shift+cmd+w`（未変更のタブを閉じる） | `Space b u` | 他を全部閉じる: `Space b o` |
| `ctrl+c`（相対パスをコピー） | `Ctrl+c` / `Space c p` | 絶対パス: `Space c P` |
| `shift+cmd+j`（次の一致を選択に追加） | `Space m n` → 続けて `n` | `q` でスキップ、`Esc` で解除 |
| `alt+cmd+j` / `shift+cmd+k`（カーソル追加） | `Space m j` / `Space m k` | |
| `tab`（Copilot / 補完 / スニペット確定） | `Tab` | Copilot → 補完候補 → スニペットの次の欄 の順。Copilot の単語単位確定は `Option+l`、提案の切り替えは `Option+]` / `Option+[` |
| `ctrl+j/k`（候補の上下） | `Ctrl+j/k` | 補完・ファイル検索の一覧で共通 |
| `alt+d`（Emmet で囲む） | `Option+d` | 展開は補完候補から `Tab` |
| `shift+cmd+s`（RuboCop 自動修正） | `Space c f` | 手動保存時にも自動で走る |
| `cmd+n` / `cmd+d`（新規ファイル / フォルダ） | エクスプローラで `a`（末尾 `/` でフォルダ） | |
| エクスプローラで `space`（プレビュー） / `ctrl+h`（閉じる） | `P` / `h` | Space は `<leader>` として使うため |
| `alt+,`（キーボードショートカット） | `Space s k` | |
| `ctrl+shift+cmd+p`（スコープの確認） | `Space u i` | |

※ `Ctrl+Enter` / `Ctrl+,` は iTerm2 の設定で CSI u を有効にした場合のみ届く。

### VSCode の標準機能

| VSCode | Neovim |
| --- | --- |
| `cmd+p` ファイルを開く | `Ctrl+p` / `Space f f`（gitignore 含む: `Space f a`） |
| `cmd+shift+f` 全体検索 | `Space /` / `Space s g` |
| 全体置換 | `Space s f` |
| `cmd+shift+p` コマンドパレット | `Space s c` / `:` |
| `cmd+shift+o` / `cmd+t` シンボル | `Space s s` / `Space s S` |
| `cmd+b` サイドバー | `Space e` |
| `F2` リネーム | `Space r n`（`grn` も可） |
| `cmd+.` クイックフィックス | `Space c a` |
| 参照 / 実装 / 型定義 | `grr` / `gI` / `gy` |
| ホバー | `K` |
| `cmd+shift+m` 問題パネル | `Space x x`、次 / 前の問題 `]d` / `[d` |
| ソース管理（差分） | `Space g d`、ブランチの差分 `Space g D`、`Space g g`（fugitive） |
| ガターの変更へ移動 / ステージ / 戻す | `]h` `[h` / `Space g s` / `Space g r` |
| Git blame / ファイル履歴 | `Space g l` / `Space g h` |
| ``ctrl+` `` ターミナル | `Ctrl+\`（中で `Esc Esc` でノーマルモード） |
| 分割 | `Space \|`（縦） / `Space -`（横） |
| Expand / Shrink Selection | `Ctrl+Space` を繰り返す / `Backspace`（ビジュアルモードで `an` / `in` も同じ） |
| Sticky Scroll | 自動（treesitter-context） |

### settings.json で再現しているもの

| settings.json | 場所 |
| --- | --- |
| `files.autoSave: afterDelay` | `autocmds.lua`（ノーマルモードで1秒後に保存。フォーマットはしない） |
| `files.trimTrailingWhitespace` / `insertFinalNewline` | `autocmds.lua` / `options.lua` |
| `editor.formatOnSave` + `defaultFormatter` | `formatting.lua`（ts/tsx: oxfmt, ruby: rubocop, その他: LSP） |
| `editor.tabSize: 2` / `wordWrap: off` | `options.lua` |
| `workbench.colorCustomizations` / `tokenColorCustomizations` | `colorscheme.lua` |
| `js/ts.updateImportsOnFileMove` / `importModuleSpecifier` | `lsp/vtsls.lua` + `explorer.lua`（ツリーでの移動時） |
| `files.associations: *.css → tailwindcss` | `lsp/tailwindcss.lua` |
| `github.copilot.enable` | `ai.lua` |
| `search.useIgnoreFiles: false` | `Space f a` / `Space s a` で gitignore されたファイルも検索 |
