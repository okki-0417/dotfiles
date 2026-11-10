# ~/.zshrc -> dotfiles/zsh/.zshrc
# 中身は rc/ 以下に役割ごとに分けてある。ここでは読み込み順だけを決める。

# シンボリックリンクを解決して、このファイルが実際に置かれているディレクトリを得る
ZSH_RC_DIR="${${(%):-%x}:A:h}/rc"

source "$ZSH_RC_DIR/path.zsh"        # PATH
source "$ZSH_RC_DIR/tools.zsh"       # nodenv / rbenv / direnv など（PATH を前提にする）
source "$ZSH_RC_DIR/prompt.zsh"      # プロンプト
source "$ZSH_RC_DIR/completion.zsh"  # 補完
source "$ZSH_RC_DIR/aliases.zsh"     # エイリアス
source "$ZSH_RC_DIR/functions.zsh"   # 関数
source "$ZSH_RC_DIR/plugins.zsh"     # 外部プラグイン（syntax-highlighting は最後に読む必要がある）

unset ZSH_RC_DIR
