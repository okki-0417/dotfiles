-- 編集補助（括弧の自動補完 / 囲み / マルチカーソル / Emmet / 画面内ジャンプ）

return {
  -- 括弧・引用符を自動で閉じる
  { "echasnovski/mini.pairs", event = "InsertEnter", opts = {} },

  -- 囲みの追加・変更・削除（s は flash に使うので gs を接頭辞にする）
  --   gsa{motion}{char} : 囲む（例: gsaiw" → 単語を "" で囲む。ビジュアル選択して gsa" でも可）
  --   gsd{char}         : 囲みを削除（例: gsd" ）
  --   gsr{old}{new}     : 囲みを変更（例: gsr"' ）
  {
    "echasnovski/mini.surround",
    event = "VeryLazy",
    opts = {
      mappings = {
        add = "gsa", delete = "gsd", replace = "gsr", find = "gsf", find_left = "gsF",
        highlight = "gsh", update_n_lines = "gsn",
      },
    },
  },

  -- テキストオブジェクトの拡張（i( / a" / iq（引用符） / ib（括弧）など）
  { "echasnovski/mini.ai", event = "VeryLazy", opts = { n_lines = 500 } },

  -- マルチカーソル
  -- VSCode: shift+cmd+j（次の一致を選択に追加） / alt+cmd+j, shift+cmd+k（カーソルを上下に追加）
  -- まずは Vim の . (繰り返し) / :%s / Ctrl+v（矩形選択）で済まないか考えるのがおすすめ
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()
      local map = vim.keymap.set
      map({ "n", "x" }, "<leader>mn", function() mc.matchAddCursor(1) end, { desc = "次の一致にカーソル追加" })
      map({ "n", "x" }, "<leader>mN", function() mc.matchAddCursor(-1) end, { desc = "前の一致にカーソル追加" })
      map({ "n", "x" }, "<leader>ms", function() mc.matchSkipCursor(1) end, { desc = "次の一致をスキップ" })
      map({ "n", "x" }, "<leader>ma", mc.matchAllAddCursors, { desc = "すべての一致にカーソル追加" })
      map({ "n", "x" }, "<leader>mj", function() mc.lineAddCursor(1) end, { desc = "下にカーソル追加" })
      map({ "n", "x" }, "<leader>mk", function() mc.lineAddCursor(-1) end, { desc = "上にカーソル追加" })
      map("x", "I", mc.insertVisual, { desc = "選択した各行の先頭に挿入" })
      map("x", "A", mc.appendVisual, { desc = "選択した各行の末尾に追加" })
      -- カーソルが複数ある間だけ有効なキー
      mc.addKeymapLayer(function(layer)
        layer({ "n", "x" }, "n", function() mc.matchAddCursor(1) end)
        layer({ "n", "x" }, "q", function() mc.matchSkipCursor(1) end)
        layer("n", "<Esc>", function()
          if not mc.cursorsEnabled() then mc.enableCursors() else mc.clearCursors() end
        end)
      end)
    end,
  },

  -- Emmet の「省略記法で囲む」（VSCode: alt+d → emmet.action.wrapWithAbbreviation）
  -- 展開は補完候補に emmet_language_server から出てくるので Tab で確定するだけ
  {
    "olrtg/nvim-emmet",
    keys = {
      { "<A-d>", function() require("nvim-emmet").wrap_with_abbreviation() end, mode = { "n", "x" }, desc = "Emmet で囲む" },
    },
  },

  -- 画面内の任意の場所へジャンプ: s + 2文字 → 表示されたラベルを押す
  -- （Vim 標準の s = 1文字消して挿入 は cl で代用できる）
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = { modes = { search = { enabled = false }, char = { enabled = false } } },
    keys = {
      { "s", function() require("flash").jump() end, mode = { "n", "x", "o" }, desc = "Flash ジャンプ" },
      { "S", function() require("flash").treesitter() end, mode = { "n", "x", "o" }, desc = "Flash 構文単位で選択" },
    },
  },

  -- TODO / FIXME コメントのハイライトと一覧
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = { { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "TODO 一覧" } },
  },

  -- プロジェクト全体の検索・置換（VSCode の検索ビューの置換）
  {
    "MagicDuck/grug-far.nvim",
    cmd = "GrugFar",
    opts = {},
    keys = {
      { "<leader>sf", function() require("grug-far").open() end, mode = { "n", "x" }, desc = "プロジェクト全体で置換" },
    },
  },
}
