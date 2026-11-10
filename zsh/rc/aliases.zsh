# エイリアス

# --- シェル操作 -------------------------------------------------------------
alias ..="cd .."
alias ~="cd ~"
alias c="cd"
alias dl="cd ~/Downloads"
alias l="ls"
alias lg="ls | grep"
alias t="touch"
alias md="mkdir"
alias gr="grep"
alias du="ncdu"
alias h="history 100"
alias hg="history 100 | grep"

# --- zsh 設定 ---------------------------------------------------------------
alias editzsh="code ~/.zshrc"
alias z="source ~/.zshrc"

# --- エディタ / AI ----------------------------------------------------------
alias code.="code ."
alias codei="code-insiders"
alias cl="claude"

# --- Git --------------------------------------------------------------------
alias g="git"
alias gs="git status"
alias gd="git diff"
alias gds="git diff --staged"
alias gl="git log"
alias ga="git add"
alias gau="git add -u"
alias gA="git add -A"
alias gc="git commit"
alias gp="git push"
alias gpu="git pull"
alias gb="git branch"
alias gb-unpushed="git branch -vv | grep -v 'origin/' | awk '{print \$1}'"
alias gchb="git checkout -b"
alias gchdev="git checkout develop"
alias gchmain="git checkout main"
alias gchp="git cherry-pick"
alias grb="git rebase"
alias grst="git reset"
alias grst1="git reset HEAD^"
alias gsta="git stash"
alias gstap="git stash pop"
alias gw="git worktree"
alias gwl="git worktree list"
alias gwa="git worktree add"
alias gwr="git worktree remove"
alias prlist="gh pr list"
# gch は functions.zsh

# --- Node (pnpm) ------------------------------------------------------------
alias n="pnpm"
alias ni="pnpm install"
alias nr="pnpm run"
alias nd="pnpm run dev"
alias nt="pnpm run typecheck"
alias nl="pnpm lint"
alias nf="pnpm format"

# --- Rust / Terraform -------------------------------------------------------
alias car="cargo"
alias cr="cargo run"
alias tera="terraform"

# --- Docker / Rails（docker compose の app コンテナ前提） -------------------
alias d="docker"
alias dp="rdps"  # docker ps
alias dc="docker compose"
alias dcu="docker compose up"
alias dcd="docker compose down"
alias rst="docker compose restart"
alias dce="docker compose exec app"
alias dcebe="docker compose exec app bundle exec"
alias r="docker compose exec app bundle exec rails"
alias rc="docker compose exec app bundle exec rails console"
alias stup="docker compose exec app bundle exec bin/setup"
alias binsu="docker compose exec app bin/setup"
# rsp / frsp は functions.zsh

# --- macOS アプリ -----------------------------------------------------------
alias opa="open -a"
alias chrome="open -a 'Google Chrome'"
alias brave="open -a 'Brave Browser'"
alias notes="open -a Notes"
alias excel="open -a 'Microsoft Excel'"
alias xlsx="open -a 'Microsoft Excel'"
alias pptx="open -a 'Microsoft PowerPoint'"

# --- 大学 -------------------------------------------------------------------
alias lsuniv="ls ~/Desktop/University/"
