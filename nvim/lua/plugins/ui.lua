-- 見た目まわり: ステータスライン / タブ（バッファ）バー / キーマップのヘルプ / アイコン

return {
  -- アイコン（Nerd Font が必要。iTerm2 のフォントを Nerd Font 版にする）
  { "echasnovski/mini.icons", lazy = true, opts = {},
    init = function()
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = {
        theme = "catppuccin",
        globalstatus = true,
        component_separators = "",
        section_separators = "",
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = { { "filename", path = 1 }, "diagnostics" },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },

  -- VSCode のエディタタブのようなバッファ一覧
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "バッファをピン留め" },
      { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "他のバッファを閉じる" },
      { "<leader>bd", function() require("mini.bufremove").delete(0) end, desc = "バッファを閉じる" },
      { "<leader>bb", "<cmd>BufferLinePick<cr>", desc = "バッファを選んで開く" },
      { "[b", "<cmd>BufferLineMovePrev<cr>", desc = "バッファを左へ移動" },
      { "]b", "<cmd>BufferLineMoveNext<cr>", desc = "バッファを右へ移動" },
    },
    dependencies = { "echasnovski/mini.bufremove" },
    opts = {
      options = {
        close_command = function(n) require("mini.bufremove").delete(n) end,
        diagnostics = "nvim_lsp",
        always_show_bufferline = true,
        show_buffer_close_icons = false,
        offsets = { { filetype = "neo-tree", text = "Explorer", highlight = "Directory", text_align = "left" } },
      },
    },
    config = function(_, opts)
      local ok, cat = pcall(require, "catppuccin.groups.integrations.bufferline")
      if ok then opts.highlights = (cat.get_theme or cat.get)() end
      require("bufferline").setup(opts)
    end,
  },

  -- ウィンドウレイアウトを崩さずにバッファを閉じる
  { "echasnovski/mini.bufremove", lazy = true },

  -- <leader> などを押して待つと、続けて押せるキーの一覧を出す
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      spec = {
        { "<leader>b", group = "バッファ" },
        { "<leader>c", group = "コード" },
        { "<leader>f", group = "ファイル検索" },
        { "<leader>g", group = "Git" },
        { "<leader>m", group = "マルチカーソル" },
        { "<leader>q", group = "終了" },
        { "<leader>s", group = "検索" },
        { "<leader>t", group = "ターミナル" },
        { "<leader>u", group = "UI" },
        { "<leader>x", group = "診断リスト" },
      },
    },
    keys = {
      { "<leader>?", function() require("which-key").show({ global = false }) end, desc = "このバッファのキーマップ" },
    },
  },

  -- インデントガイド
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = { indent = { char = "│" }, scope = { enabled = false } },
  },

  -- 通知をきれいに表示
  { "j-hui/fidget.nvim", event = "VeryLazy", opts = { notification = { override_vim_notify = true } } },
}
