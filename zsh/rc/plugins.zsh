# 外部プラグイン・連携

# fzf（Ctrl-R の履歴検索など）
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh

# iTerm2 のシェル統合
[[ -f ~/.iterm2_shell_integration.zsh ]] && source ~/.iterm2_shell_integration.zsh

# 入力中に過去のコマンドを薄く表示して提案する
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# コマンドを色分けする（公式指定により、必ず最後に読み込む）
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
