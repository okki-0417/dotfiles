#!/usr/bin/env bash
# Terminal.app に profile.json の内容を反映する。何度実行してもOK。
# Terminal.app の中から実行しても構わない（起動中でも反映される）。
set -eu

DIR="$(cd "$(dirname "$0")" && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# profile.json → .terminal ファイルを生成（色・フォントはバイナリなのでスクリプトで変換する）
name="$(osascript -l JavaScript "$DIR/build.js" "$DIR/profile.json" "$TMP/profile.terminal")"
# Terminal.app はファイル内の name ではなくファイル名をプロファイル名にするので、ファイル名を揃える
mv "$TMP/profile.terminal" "$TMP/$name.terminal"

# 同名のプロファイルがあると上書きされず「名前 1」として追加されるので、先に消しておく
# （既定のプロファイルは消せないので、いったん Basic に戻す）
osascript - "$name" <<'OSA'
on run argv
  set profileName to item 1 of argv
  tell application "Terminal"
    if exists settings set profileName then
      set default settings to settings set "Basic"
      set startup settings to settings set "Basic"
      delete settings set profileName
    end if
  end tell
end run
OSA

# .terminal を開くと Terminal.app に読み込まれる。読み込んだプロファイルのウィンドウが1つ開く。
open "$TMP/$name.terminal"

# 読み込みが終わるのを待ってから、既定・起動時のプロファイルにする
osascript - "$name" <<'OSA'
on run argv
  set profileName to item 1 of argv
  tell application "Terminal"
    repeat 50 times
      if exists settings set profileName then exit repeat
      delay 0.1
    end repeat
    set default settings to settings set profileName
    set startup settings to settings set profileName
  end tell
end run
OSA

# --- プロファイル以外の設定 ----------------------------------------------------
# キー長押しでアクセント候補を出さず、キーリピートにする（Vim の hjkl 連打用）。Terminal.app の再起動後に反映
defaults write com.apple.Terminal ApplePressAndHoldEnabled -bool false

echo "Terminal.app にプロファイル「${name}」を反映しました。"
