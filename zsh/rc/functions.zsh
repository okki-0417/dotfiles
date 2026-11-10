# 関数

# --- 安全装置 ---------------------------------------------------------------

# rm -rf / rm -fr のときだけ確認を挟む（それ以外は普通の rm）
function rm() {
  if ! echo "$@" | grep -E '(-rf|-fr)' > /dev/null; then
    /bin/rm "$@"
    return
  fi

  echo -e "\033[31m"
  echo "======================================================================"
  echo "  ⚠️ 警告: 復元不可能な 'rm -rf' 相当の操作が検出されました。"
  echo "  引数: $@"
  echo "======================================================================"
  echo -e "\033[0m"

  # 非対話的環境（TTYなし）の場合は確認をスキップ
  if [[ ! -t 0 ]]; then
    echo "非対話的環境のため、確認なしで実行します。"
    /bin/rm "$@"
    return $?
  fi

  echo "本当に実行しますか？ (y/N): "
  read -r confirm
  if [[ "$confirm" =~ ^[yY]$ ]]; then
    echo -e "\033[33m実行中...\033[0m"
    /bin/rm "$@"
    echo -e "\033[32m完了しました。\033[0m"
  else
    echo "操作をキャンセルしました。"
    return 1
  fi
}

# git checkout のラッパー。`gch -- .`（変更の全破棄）のときだけ確認を挟む
function gch() {
  if [[ "$1" == "--" && "$2" == "." ]]; then
    local app_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
    echo "⚠️ 本当に「${app_name}」の変更を破棄しますか？ (Y/N)"
    read -r answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
      git checkout -- .
    else
      echo "キャンセルしました。"
    fi
  else
    git checkout "$@"
  fi
}

# --- ディレクトリ移動 -------------------------------------------------------

# ディレクトリを作って移動
function mkcd() {
  mkdir -p "$1"
  cd "$1"
}

# ghq 管理下のリポジトリを fzf で選んで移動
function cdr() {
  local repo=$(ghq list --full-path | fzf)
  [ -n "$repo" ] && cd "$repo"
}

# --- RSpec（docker compose の app コンテナ前提） ----------------------------

function rsp() {
  docker compose exec app bundle exec rspec $1 --format documentation
}

# 前回失敗したテストだけ再実行
function frsp() {
  docker compose exec app bundle exec rspec $1 --only-failures
}

# --- macOS アプリ -----------------------------------------------------------

# 起動中のアプリ名を1行ずつ出力
function lsapp() {
  local raw=$(osascript -e 'tell application "System Events" to get name of processes whose background only is false')
  local app
  for app in "${(@s:, :)raw}"; do
    echo "$app"
  done
}

# appq           : 除外リスト以外の起動中アプリをすべて終了
# appq Slack ... : 指定したアプリを終了
function appq() {
  local apps app
  if [[ $# -gt 0 ]]; then
    apps=("$@")
  else
    local exclude=("iTerm2" "Electron" "Google Chrome" "Code")
    echo "\"$exclude\"以外を終了します。"
    apps=("${(@f)$(lsapp)}")
    apps=("${(@)apps:|exclude}")  # 除外リストを取り除く
  fi

  for app in "${apps[@]}"; do
    echo "終了中: $app"
    osascript -e "quit app \"$app\"" 2>/dev/null
  done
}

# ~/Downloads の screencapture-* 画像を確認してから削除
function rmsc() {
  local files=(~/Downloads/screencapture-*(N))
  echo "~/Downloads内のscreencapture-で始まる画像を削除します"
  if [[ ${#files[@]} -eq 0 ]]; then
    echo "削除対象のファイルがありません"
    return
  fi

  echo "削除対象: ${#files[@]}件"
  ls -la "${files[@]}"
  echo "本当に削除しますか？ (Y/N)"
  read -r answer
  if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
    rm "${files[@]}"
    echo "削除完了"
  else
    echo "キャンセルしました"
  fi
}

# --- 大学 -------------------------------------------------------------------

function cduniv() {
  cd ~/Desktop/University
  ls
}

# mvuniv <ファイル名> <科目フォルダ> : Downloads から University/<科目> へ移動
function mvuniv() {
  mkdir -p ~/Desktop/University/$2
  mv ~/Downloads/$1 ~/Desktop/University/$2/$1
  cd ~/Desktop/University/$2
}
