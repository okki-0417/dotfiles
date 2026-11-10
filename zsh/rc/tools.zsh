# 言語のバージョン管理ツールなど、シェルに組み込むツールの初期化

export EDITOR="nvim"
export VISUAL="nvim"

eval "$(nodenv init - zsh)"
eval "$(rbenv init - zsh)"
eval "$(direnv hook zsh)"

# Vite+ (https://viteplus.dev)
source "$HOME/.vite-plus/env"
