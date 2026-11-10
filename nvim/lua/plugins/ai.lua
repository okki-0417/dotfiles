-- GitHub Copilot（VSCode: github.copilot.enable）
-- 初回は :Copilot auth でログインする
--
--   Tab      : 提案を確定（completion.lua で補完メニューより優先している）
--   Option+l : 単語単位で確定     Option+] / Option+[ : 次 / 前の提案     Ctrl+] : 提案を消す

return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  opts = {
    suggestion = {
      enabled = true,
      auto_trigger = true,
      keymap = {
        accept = false, -- Tab は blink.cmp 側で処理
        accept_word = false, -- Option キーは下の config で割り当てる
        accept_line = false,
        next = false,
        prev = false,
        dismiss = "<C-]>",
      },
    },
    panel = { enabled = false },
    filetypes = {
      ["*"] = true,
      markdown = true,
      text = true,
      gitcommit = false, -- scminput: false
      gitrebase = false,
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)
    local suggestion = require("copilot.suggestion")
    local option = require("config.option_key")
    option.map("i", "l", suggestion.accept_word, { desc = "Copilot: 単語単位で確定" })
    option.map("i", "]", suggestion.next, { desc = "Copilot: 次の提案" })
    option.map("i", "[", suggestion.prev, { desc = "Copilot: 前の提案" })
  end,
}
