#!/usr/bin/env bash
# iTerm2 の全体設定（プロファイル以外）を適用する。何度実行してもOK。
# プロファイル（フォント・配色・キー割り当てなど）は iterm2/profile.json で管理している。
# 反映には iTerm2 の再起動が必要。
set -eu

d() { defaults write com.googlecode.iterm2 "$@"; }

# --- 見た目 -------------------------------------------------------------------
d HideScrollbar -bool true                    # スクロールバーを隠す
d StretchTabsToFillBar -bool true             # タブをタブバーいっぱいに広げる
d SeparateWindowTitlePerTab -bool true        # タブごとにウィンドウタイトルを持つ
d ShowFullScreenTabBar -bool true             # フルスクリーンでもタブバーを表示
d UseLionStyleFullscreen -bool false          # フルスクリーンを macOS 標準方式にしない（高速に切り替え）
d AdjustWindowForFontSizeChange -bool false   # フォントサイズ変更でウィンドウサイズを変えない

# --- 起動・終了 ---------------------------------------------------------------
d OpenNoWindowsAtStartup -bool true           # 起動時にウィンドウを開かない（前回のウィンドウを復元）
d PromptOnQuit -bool true                     # 終了時に確認する

# --- 操作 ---------------------------------------------------------------------
d AllowClipboardAccess -bool true             # ターミナル内のアプリからクリップボードにアクセスを許可（Neovim のヤンク共有）
d ApplePressAndHoldEnabled -bool false        # キー長押しでアクセント候補を出さず、キーリピートにする（Vim の hjkl 連打用）
d OptionClickMovesCursor -bool false          # Option+クリックでカーソル移動しない

# --- 既定のプロファイル -------------------------------------------------------
d "Default Bookmark Guid" -string "dotfiles-default-profile"   # profile.json の Guid

echo "iTerm2 の設定を書き込みました。iTerm2 を再起動すると反映されます。"
