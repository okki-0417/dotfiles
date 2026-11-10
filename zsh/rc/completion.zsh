# 補完

autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit  # bash 用の補完定義も使えるようにする

# 大文字・小文字を区別せずに補完する
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# terraform（tenv でインストールしたもの）
if [[ -x ~/.tenv/Terraform/1.11.1/terraform ]]; then
  complete -o nospace -C ~/.tenv/Terraform/1.11.1/terraform terraform
fi
