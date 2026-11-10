-- 補完（VSCode の IntelliSense のサジェスト）とスニペット
--
-- スニペットは VSCode で使っていた dotfiles/vscode/snippets/*.json をそのまま読み込む。
-- （VSCode の言語名 → Neovim のファイルタイプの対応は nvim/snippets/package.json に書いてある）
--
-- 補完メニューの操作（VSCode の keybindings.json に合わせている）
--   Tab        : Copilot の提案があれば確定 → 候補を確定 → スニペットの次の入力欄へ
--   Ctrl+j / k : 候補の上下（↓ / ↑ も可）
--   Ctrl+Space : 補完を手動で出す     Ctrl+e : 閉じる
--   Ctrl+b / f : ドキュメントをスクロール

-- ~/.config/nvim はシンボリックリンクなので、実体（dotfiles/nvim）からの相対パスが使えるよう解決しておく
local snippets_dir = vim.fn.resolve(vim.fn.stdpath("config")) .. "/snippets"

return {
  "saghen/blink.cmp",
  version = "1.*", -- ビルド済みのバイナリを使う
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = { "rafamadriz/friendly-snippets" },
  opts = {
    keymap = {
      preset = "none",
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-e>"] = { "hide", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = {
        function() -- Copilot の提案を優先（VSCode: tab → inlineSuggest.commit）
          local ok, s = pcall(require, "copilot.suggestion")
          if ok and s.is_visible() then
            s.accept()
            return true
          end
        end,
        "select_and_accept",
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      list = { selection = { preselect = true, auto_insert = false } },
      menu = { border = "rounded" },
      documentation = { auto_show = true, auto_show_delay_ms = 200, window = { border = "rounded" } },
      ghost_text = { enabled = false }, -- Copilot のゴーストテキストと被らないように
    },
    signature = { enabled = true, window = { border = "rounded" } },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        snippets = {
          opts = {
            friendly_snippets = true,
            search_paths = { snippets_dir },
          },
        },
      },
    },
    cmdline = {
      keymap = { preset = "cmdline", ["<C-j>"] = { "select_next", "fallback" }, ["<C-k>"] = { "select_prev", "fallback" } },
      completion = { menu = { auto_show = true } },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
