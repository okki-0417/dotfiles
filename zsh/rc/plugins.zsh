# 外部プラグイン・連携
# プラグインは Homebrew で入れる:
#   brew install fzf zsh-autosuggestions zsh-syntax-highlighting

BREW_SHARE="/opt/homebrew/share"

# fzf（Ctrl-R の履歴検索 / Ctrl-T のファイル選択など）
(( $+commands[fzf] )) && source <(fzf --zsh)

# iTerm2 のシェル統合
[[ -f ~/.iterm2_shell_integration.zsh ]] && source ~/.iterm2_shell_integration.zsh

# 入力中に過去のコマンドを薄く表示して提案する
[[ -f $BREW_SHARE/zsh-autosuggestions/zsh-autosuggestions.zsh ]] &&
  source $BREW_SHARE/zsh-autosuggestions/zsh-autosuggestions.zsh

# コマンドを色分けする（公式指定により、必ず最後に読み込む）
[[ -f $BREW_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] &&
  source $BREW_SHARE/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

unset BREW_SHARE
