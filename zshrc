export PATH="/opt/homebrew/bin:$PATH"

export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/.cargo/bin"

# Gitブランチ名を取得する関数（リアルタイム更新対応）
git_branch() {
  branch=$(git branch --show-current 2>/dev/null)
  if [[ -n "$branch" ]]; then
    echo " %F{250}($branch)%f"
  fi
}

# プロンプトの更新関数（ディレクトリ移動時に再評価）
update_prompt() {
  export PS1="%K{235}%F{cyan}%n@%m%f %F{49}%~%f$(git_branch)%k %F{2}❯%f "
}

# `precmd` フックに追加（毎回プロンプトを更新）
autoload -Uz add-zsh-hook
add-zsh-hook precmd update_prompt

alias editzsh="code ~/.zshrc"
alias z="source ~/.zshrc"

alias codei="code-insiders"
alias code.="code ."

alias du="ncdu"

alias g="git"
alias gchdev="git checkout develop"
alias gchmain="git checkout main"
alias gchb="git checkout -b"
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log"
alias ga="git add"
alias gau="git add -u"
alias gchp="git cherry-pick"
alias gA="git add -A"
alias gc="git commit"
alias gp="git push"
alias gb="git branch"
alias gb-unpushed="git branch -vv | grep -v 'origin/' | awk '{print \$1}'"
alias grst="git reset"
alias grst1="git reset HEAD^"
alias grb="git rebase"
alias gsta="git stash"
alias gstap="git stash pop"
alias gpu="git pull"
alias prlist="gh pr list"

alias h="history 100"
alias hg="history 100 | grep"
alias gr="grep"

alias chrome="open -a 'Google Chrome'"
alias brave="open -a 'Brave Browser'"
alias notes="open -a Notes"
alias excel="open -a 'Microsoft Excel'"
alias pptx="open -a 'Microsoft PowerPoint'"
alias op="open -a"
alias pptx="open -a 'Microsoft PowerPoint'"
alias xlsx="open -a 'Microsoft Excel'"

alias cl="claude"

alias t="touch"
alias md="mkdir"
alias l="ls"
alias lg="ls | grep"

alias ..="cd .."
alias ~="cd ~"
alias c="cd"
alias dl="cd ~/Downloads"

alias car="cargo"
alias cr="cargo run"
alias tera="terraform"
alias n="pnpm"
alias nd="pnpm run dev"
alias nr="pnpm run"
alias nt="pnpm run typecheck"
alias ni="pnpm install"
alias nl="pnpm lint"
alias nf="pnpm format"

alias d="docker"
alias dp="rdps" #docker ps
alias dc="docker compose"
alias dcd="docker compose down"
alias dcu="docker compose up"
alias dce="docker compose exec app"
alias dcebe="docker compose exec app bundle exec"
alias rst="docker compose restart"
alias stup="docker compose exec app bundle exec bin/setup"
alias binsu="docker compose exec app bin/setup"
alias r="docker compose exec app bundle exec rails"
alias rc="docker compose exec app bundle exec rails console"


alias lsuniv="ls ~/Desktop/University/"

function rm() {
  # 渡された引数を文字列としてチェックし、-r/R と -f の組み合わせがあるか確認
  if echo "$@" | grep -E '(-rf|-fr)' > /dev/null; then

    # 危険な操作が検出された場合の警告と確認
    echo -e "\033[31m" # 文字色を赤色に設定
    echo "======================================================================"
    echo "  ⚠️ 警告: 復元不可能な 'rm -rf' 相当の操作が検出されました。"
    echo "  引数: $@"
    echo "======================================================================"
    echo -e "\033[0m" # 文字色をリセット

    # 非対話的環境（TTYなし）の場合は確認をスキップ
    if [[ ! -t 0 ]]; then
      echo "非対話的環境のため、確認なしで実行します。"
      /bin/rm "$@"
      return $?
    fi

    echo "本当に実行しますか？ (y/N): "
    read -r confirm

    if [[ "$confirm" =~ ^[yY]$ ]]; then
      # 'y'または'Y'が入力された場合、元の rm コマンドを実行
      echo -e "\033[33m実行中...\033[0m" # '実行中'を黄色で表示
      /bin/rm "$@"
      echo -e "\033[32m完了しました。\033[0m" # '完了しました'を緑色で表示
    else
      # それ以外の場合、操作をキャンセル
      echo "操作をキャンセルしました。"
      return 1
    fi

  else
    # 危険な組み合わせでなければ、安全な /bin/rm -i を実行
    /bin/rm "$@"
  fi
}

function gch() {
  if [[ "$1" == "--" && "$2" == "." ]]; then
    app_name=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
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

function frsp() {
  docker compose exec app bundle exec rspec $1 --only-failures
}

function rsp() {
  docker compose exec app bundle exec rspec $1 --format documentation
}

function mkcd() {
  mkdir -p "$1"
  cd "$1"
}

function cdr() {
  # git管理されているプロジェクトのディレクトリに移動
  local repo=$(ghq list --full-path | fzf)
  [ -n "$repo" ] && cd "$repo"
}

function lsapp() {
  local raw_output
  raw_output=$(osascript -e 'tell application "System Events" to get name of processes whose background only is false')

  local running_apps=("${(@s:,:)raw_output}")
  # 各要素の前後の空白を削除して表示
  for i in {1..${#running_apps[@]}}; do
    running_apps[$i]="${running_apps[$i]## }"
    running_apps[$i]="${running_apps[$i]%% }"
    echo "$running_apps[$i]"
  done
}

function appq() {
  # 引数が与えられた場合はそれらのアプリを終了
  if [[ $# -gt 0 ]]; then
    for app in "$@"; do
      echo "終了中: $app"
      osascript -e "quit app \"$app\"" 2>/dev/null
    done
    return
  fi

  # 引数がない場合は従来の挙動
  local exclude=("iTerm2" "Electron" "Google Chrome" "Code")
  echo "\"$exclude\"以外を終了します。"

  local raw_output
  raw_output=$(osascript -e 'tell application "System Events" to get name of processes whose background only is false')

  local running_apps=("${(@s:,:)raw_output}")
  # 各要素の前後の空白を削除
  for i in {1..${#running_apps[@]}}; do
    running_apps[$i]="${running_apps[$i]## }"
    running_apps[$i]="${running_apps[$i]%% }"
  done

  for app in "${running_apps[@]}"; do
    local should_skip=false
    for ex in "${exclude[@]}"; do
      if [[ "$app" == "$ex" ]]; then
        should_skip=true
        break
      fi
    done

    if [[ $should_skip == false ]]; then
      echo "終了中: $app"
      osascript -e "quit app \"$app\"" 2>/dev/null
    fi
  done
}

function cduniv() {
  cd ~/Desktop/University
  ls
}

function rmsc() {
  echo "~/Downloads内のscreencapture-で始まる画像を削除します"
  local files=(~/Downloads/screencapture-*(N))
  if [[ ${#files[@]} -eq 0 ]]; then
    echo "削除対象のファイルがありません"
  else
    echo "削除対象: ${#files[@]}件"
    ls -la ~/Downloads/screencapture-*
    echo "本当に削除しますか？ (Y/N)"
    read -r answer
    if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
      rm ~/Downloads/screencapture-*
      echo "削除完了"
    else
      echo "キャンセルしました"
    fi
  fi
}

function mvuniv() {
  mkdir -p ~/Desktop/University/$2
  mv ~/Downloads/$1 ~/Desktop/University/$2/$1
  cd ~/Desktop/University/$2
}

# Zshのタブ補完機能をさらに強化することができます。たとえば、fuzzy completion という曖昧検索を導入することで、ディレクトリやファイルの補完をより強力にできます。
autoload -Uz compinit
compinit
zstyle ":completion:*" matcher-list "m:{a-zA-Z}={A-Za-z}"

# zsh-autosuggestions: コマンドラインで過去に入力したコマンドをリアルタイムで提案してくれます。
# zsh-syntax-highlighting: コマンドライン入力をシンタックスハイライトで色分けし、視覚的にわかりやすくします。
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PATH=$PATH:/opt/homebrew/bin

eval "$(nodenv init - zsh)"
eval "$(rbenv init - zsh)"

export PATH=$PATH:~/sl


test -e ~/.iterm2_shell_integration.zsh && source ~/.iterm2_shell_integration.zsh || true
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C ~/.tenv/Terraform/1.11.1/terraform terraform
autoload -Uz compinit && compinit
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

export PATH="$HOME/.local/bin:$PATH"
eval "$(direnv hook zsh)"

# pnpm
export PNPM_HOME="/Users/mumumu/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
