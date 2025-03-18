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

alias g="git"
alias gch="git checkout"
alias gchdev="git checkout develop"
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log"
alias ga="git add"
alias gA="git add -A"
alias gc="git commit"
alias gp="git push"
alias gb="git branch"
alias grst="git reset"
alias grst1="git reset HEAD^"
alias grb="git rebase"
alias gsta="git stash"
alias gstap="git stash pop"
alias gpu="git pull"
alias prlist="gh pr list"

alias h="history 100"
alias hg="history 100 | grep"

alias chrome="open -a 'Google Chrome'"
alias op="open -a"

alias t="touch"
alias md="mkdir"
alias l="ls"

alias lsapp="osascript -e 'tell application \"System Events\" to get name of processes whose background only is false'"
alias osa="osascript -e"

alias cd~="cd ~"
alias cd..="cd .."
alias ..="cd .."
alias ~="cd ~"
alias c="cd"

alias rai="rails"
alias car="cargo"
alias tera="terraform"
alias n="npm"
alias nd="npm run dev"

alias d="docker"
alias dp="docker ps"
alias dc="docker compose"
alias dcd="docker compose down"
alias dcu="docker compose up"
alias dce="docker compose exec app"
alias dcrst="docker compose restart"
alias dcebe="docker compose exec app bundle exec"
alias dceber="docker compose exec app bundle exec rails"
alias dceberc="docker compose exec app bundle exec rails console"
alias dcebersp="docker compose exec app bundle exec rspec"

alias lsuniv="ls ~/Desktop/University/"

function dceberspf() {
  docker compose exec app bundle exec rspec $1 --only-failures
}

function dceberspd() {
  docker compose exec app bundle exec rspec $1 --format documentation
}

function dceberspfd() {
  docker compose exec app bundle exec rspec $1 --only-failures --format documentation
}

function mkcd() {
  mkdir -p "$1"
  cd "$1"
}

function rcd() {
  local repo=$(ghq list --full-path | fzf)
  [ -n "$repo" ] && cd "$repo"
}

function appq() {
  if [ -z "$1" ]; then
    echo "使用方法: quitapp <アプリ名>"
    return 1
  fi
  osascript -e "quit app \"$1\""
  echo "\"$1\" を終了しました。"
}


function rmexcept() {
  if [ -z "$1" ]; then
    echo "使用方法: rmexcept <除外するファイルまたはディレクトリ名>"
    return 1
  fi

  # 除外パスが存在するか確認
  if [ ! -e "$1" ]; then
    echo "指定したファイルまたはディレクトリは存在しません: $1"
    return 1
  fi

  echo "次のファイルとディレクトリを削除します（$1 を除く）:"

  # 除外対象を除いた一覧表示
  find . -mindepth 1 \( -path "./$1" -prune \) -o -print

  echo -n "本当に削除しますか？ (y/N): "
  read -r confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    # 削除を実行（pruneで除外対象を保護）
    find . -mindepth 1 \( -path "./$1" -prune \) -o -exec rm -rf {} +
    echo "削除が完了しました。"
  else
    echo "削除をキャンセルしました。"
  fi
}


function tukareta() {
  echo "頑張れ~"
}

function cduniv() {
  cd /Users/mumumu/Desktop/University
  ls
}

function cduniv() {
  cd /Users/mumumu/Desktop/University/$1
}

function mvuniv() {
  mkdir -p /Users/mumumu/Desktop/University/$2
  mv /Users/mumumu/Downloads/$1 /Users/mumumu/Desktop/University/$2/$1
  cd /Users/mumumu/Desktop/University/$2
}

# 現在のブランチ名をクリップボードにコピー
function gbn() {
  git branch --contains | cut -d " " -f 2 | pbcopy
  git branch --contains | cut -d " " -f 2
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

export PATH=$PATH:/Users/mumumu/sl

test -e /Users/mumumu/.iterm2_shell_integration.zsh && source /Users/mumumu/.iterm2_shell_integration.zsh || true
export PATH="/usr/local/opt/mysql-client/bin:$PATH"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /Users/mumumu/.tenv/Terraform/1.11.1/terraform terraform
autoload -Uz compinit && compinit
