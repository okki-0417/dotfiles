# 言語のバージョン管理ツールなど、シェルに組み込むツールの初期化

eval "$(nodenv init - zsh)"
eval "$(rbenv init - zsh)"
eval "$(direnv hook zsh)"

# Vite+ (https://viteplus.dev)
source "$HOME/.vite-plus/env"
