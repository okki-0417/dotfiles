# プロンプトをカスタマイズするために使われる PS1 という変数を設定しています
export PS1='%F{33}%n@%m:%c 🐈 %#%f '

alias h='history 100'
alias gg='git grep'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias gl='git log'
alias ga='git add'
alias gA='git add -A'
alias gc='git commit'
alias gre='git rebase'
alias gp='git push'
alias gb='git branch'
alias gch='git checkout'
alias hg='history 100 | grep'
alias chrome='open -a "Google Chrome"'
alias op='open -a'

alias smcb='cd /Users/mumumu/src/github.com/ostance/smcb'
alias dce='docker-compose exec app'
alias dcebe='docker-compose exec app bundle exec'
alias dc='docker-compose'
alias dcd='docker-compose down'
alias dcu='docker-compose up'
alias dp='docker ps'


function mkcd() {
  mkdir -p "$1"
  cd "$1"
}

function tukareta() {
  echo "頑張れ~"
}

function univ() {
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

function gbn() {
  git branch --contains | cut -d " " -f 2 | pbcopy
  git branch --contains | cut -d " " -f 2
}

# Zshのタブ補完機能をさらに強化することができます。たとえば、fuzzy completion という曖昧検索を導入することで、ディレクトリやファイルの補完をより強力にできます。
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

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
