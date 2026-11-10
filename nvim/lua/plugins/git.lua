-- Git（VSCode のソース管理ビュー / ガターの差分表示 / Diff エディタ）

return {
  -- 行番号の横に追加・変更・削除を表示し、変更単位（hunk）で操作する
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" }, change = { text = "▎" }, delete = { text = "" },
        topdelete = { text = "" }, changedelete = { text = "▎" }, untracked = { text = "▎" },
      },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc })
        end
        map("n", "]h", function() gs.nav_hunk("next") end, "次の変更箇所")
        map("n", "[h", function() gs.nav_hunk("prev") end, "前の変更箇所")
        map({ "n", "x" }, "<leader>gs", ":Gitsigns stage_hunk<cr>", "変更箇所をステージ")
        map({ "n", "x" }, "<leader>gr", ":Gitsigns reset_hunk<cr>", "変更箇所を元に戻す")
        map("n", "<leader>gS", gs.stage_buffer, "ファイルをステージ")
        map("n", "<leader>gR", gs.reset_buffer, "ファイルを元に戻す")
        map("n", "<leader>gp", gs.preview_hunk_inline, "変更箇所の差分を表示")
        map("n", "<leader>gl", function() gs.blame_line({ full = true }) end, "この行の blame")
        map("n", "<leader>gL", gs.toggle_current_line_blame, "行 blame の常時表示を切り替え")
        map({ "o", "x" }, "ih", ":<C-u>Gitsigns select_hunk<cr>", "変更箇所（テキストオブジェクト）")
      end,
    },
  },

  -- 差分ビュー（VSCode の Diff エディタ / ファイル履歴）
  {
    "sindrets/diffview.nvim",
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "作業ツリーの差分（ソース管理ビュー）" },
      { "<leader>gD", "<cmd>DiffviewOpen origin/HEAD...HEAD<cr>", desc = "ブランチ全体の差分（PR 相当）" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "このファイルの履歴" },
      { "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "リポジトリの履歴" },
      { "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "差分ビューを閉じる" },
    },
    opts = { enhanced_diff_hl = true },
  },

  -- Git コマンドを Vim から（:Git commit / :Git push / :Git blame など）
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gread", "Gwrite", "Gdiffsplit" },
    keys = { { "<leader>gg", "<cmd>Git<cr>", desc = "Git ステータス（fugitive）" } },
  },
}
