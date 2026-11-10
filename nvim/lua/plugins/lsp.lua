-- LSP（定義ジャンプ / 補完の元データ / 診断 / リネームなど VSCode の言語機能）
--
-- サーバーは mason が自動でインストールする（:Mason で一覧・追加）。
-- サーバーごとの設定は nvim/lsp/<サーバー名>.lua に置く（Neovim 0.11 の vim.lsp.config の仕組み）。

-- 使う言語サーバー（mason-lspconfig の名前）
local servers = {
  "vtsls",                 -- TypeScript / JavaScript
  "ruby_lsp",              -- Ruby（RuboCop の診断も ruby-lsp 経由で出る）
  "tailwindcss",           -- Tailwind CSS（files.associations: *.css → tailwindcss）
  "cssls",
  "html",
  "jsonls",
  "emmet_language_server", -- Emmet
  "lua_ls",                -- Neovim 設定用
  "rust_analyzer",
}

-- LSP が使えるバッファでだけ有効になるキーマップ
-- Neovim 0.11 標準: K（ホバー） / grn（リネーム） / gra（コードアクション） / grr（参照） / gri（実装） / gO（シンボル）
local function on_attach(ev)
  local function map(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
  end
  local tb = function(name) return function() require("telescope.builtin")[name]() end end

  map("n", "gd", tb("lsp_definitions"), "定義へジャンプ")
  map("n", "<C-CR>", tb("lsp_definitions"), "定義へジャンプ (ctrl+enter)") -- 端末が Ctrl+Enter を送れる場合
  map("n", "gD", vim.lsp.buf.declaration, "宣言へジャンプ")
  map("n", "grr", tb("lsp_references"), "参照一覧")
  map("n", "gI", tb("lsp_implementations"), "実装へジャンプ")
  map("n", "gy", tb("lsp_type_definitions"), "型定義へジャンプ")
  map("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "ホバー（ドキュメント）")
  map("n", "<leader>rn", vim.lsp.buf.rename, "リネーム (F2)")
  map("n", "<leader>cr", vim.lsp.buf.rename, "リネーム (F2)")
  map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "コードアクション (cmd+.)")
  map("n", "<leader>co", function()
    vim.lsp.buf.code_action({ apply = true, context = { only = { "source.organizeImports" }, diagnostics = {} } })
  end, "import を整理")
  map("n", "<leader>uh", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
  end, "インレイヒントの切り替え")
end

return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason（ツール管理）" } },
    opts = { ui = { border = "rounded" } },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = servers,
      -- インストール済みのサーバーを自動で vim.lsp.enable する
      -- rubocop は ruby-lsp が内部で実行するので、二重に診断が出ないよう除外
      automatic_enable = { exclude = { "rubocop" } },
    },
    config = function(_, opts)
      -- 補完候補を blink.cmp で受け取れるようにする
      local ok, blink = pcall(require, "blink.cmp")
      if ok then vim.lsp.config("*", { capabilities = blink.get_lsp_capabilities() }) end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("my_lsp_attach", { clear = true }),
        callback = on_attach,
      })

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = true },
        virtual_text = { spacing = 2, prefix = "●" },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = "󰌵 ",
          },
        },
      })

      require("mason-lspconfig").setup(opts)
    end,
  },

  -- 各サーバーの既定設定（cmd / filetypes / root_markers）を提供する
  { "neovim/nvim-lspconfig", lazy = true },

  -- Neovim の Lua API の補完（この設定ファイルを書くとき用）
  { "folke/lazydev.nvim", ft = "lua", opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } } },

  -- 問題パネル（VSCode: cmd+shift+m）
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    opts = {},
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "問題パネル（全体）" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "問題パネル（このファイル）" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "アウトライン" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>", desc = "quickfix リスト" },
    },
  },
}
