-- GitHub Copilot（VSCode: github.copilot.enable）
-- 初回は :Copilot auth でログインする
--
--   Tab      : 提案を確定（completion.lua で補完メニューより優先している）
--   Alt+l    : 単語単位で確定     Alt+n / Alt+p : 次 / 前の提案     Ctrl+] : 提案を消す

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
        accept_word = "<A-l>",
        accept_line = false,
        next = "<A-n>",
        prev = "<A-p>",
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
}
