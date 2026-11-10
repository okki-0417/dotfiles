-- プラグインマネージャ lazy.nvim のブートストラップ
-- lua/plugins/ 以下の *.lua をすべて読み込む（1ファイル = 1つの責務）

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none", "--branch=stable",
    "https://github.com/folke/lazy.nvim.git", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "catppuccin", "habamax" } },
  rocks = { enabled = false },                  -- luarocks が必要なプラグインは使わない
  checker = { enabled = true, notify = false }, -- 更新チェックだけ（:Lazy で確認）
  change_detection = { notify = false },
  ui = { border = "rounded" },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin", "netrwPlugin" },
    },
  },
})
