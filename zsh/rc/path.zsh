# PATH の設定
# 上にあるものほど優先される。typeset -U で重複は自動的に除去される。

typeset -U path PATH

export PNPM_HOME="$HOME/Library/pnpm"

path=(
  $PNPM_HOME
  $HOME/.local/bin
  /opt/homebrew/opt/openjdk/bin
  /opt/homebrew/bin
  $path
  $HOME/go/bin
  $HOME/.cargo/bin
  $HOME/sl
)
