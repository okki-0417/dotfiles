-- ~/.config/nvim -> dotfiles/nvim
-- 中身は lua/config（エディタ本体の設定）と lua/plugins（プラグインごとの設定）に分けてある。
-- ここでは読み込み順だけを決める。

vim.g.mapleader = " "       -- <leader> = Space
vim.g.maplocalleader = "\\"

require("config.options")   -- オプション（settings.json 相当）
require("config.keymaps")   -- プラグインに依存しないキーマップ（keybindings.json 相当）
require("config.autocmds")  -- 自動保存・末尾空白削除など
require("config.lazy")      -- プラグインマネージャ（lazy.nvim）と lua/plugins/*.lua の読み込み
