-- Neovim 設定用の Lua
return {
  settings = {
    Lua = {
      workspace = { checkThirdParty = false },
      completion = { callSnippet = "Replace" },
      hint = { enable = true },
    },
  },
}
