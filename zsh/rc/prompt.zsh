# プロンプト
# 例: mumumu@MacBookPro ~/src/dotfiles (main) ❯

# 現在の Git ブランチ名（Git 管理外なら何も出さない）
git_branch() {
  local branch=$(git branch --show-current 2>/dev/null)
  if [[ -n "$branch" ]]; then
    echo " %F{250}($branch)%f"
  fi
}

# コマンド実行のたびにプロンプトを作り直す（ブランチ切り替えを反映するため）
update_prompt() {
  PS1="%K{235}%F{cyan}%n@%m%f %F{49}%~%f$(git_branch)%k %F{2}❯%f "
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd update_prompt
