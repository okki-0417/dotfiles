-- 統合ターミナル（VSCode: ctrl+`）
--   Ctrl+\ : ターミナルを開閉（ターミナル内でも有効）
--   ターミナル内で Esc 2回 → ノーマルモード（スクロールやコピーができる）

return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { [[<C-\>]], desc = "ターミナルを開閉" },
    { "<leader>tt", "<cmd>ToggleTerm direction=horizontal<cr>", desc = "ターミナル（下）" },
    { "<leader>tf", "<cmd>ToggleTerm direction=float<cr>", desc = "ターミナル（フロート）" },
    { "<leader>tv", "<cmd>ToggleTerm direction=vertical size=80<cr>", desc = "ターミナル（右）" },
  },
  opts = {
    open_mapping = [[<C-\>]],
    direction = "horizontal",
    size = 15,
    float_opts = { border = "rounded" },
  },
}
