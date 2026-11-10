-- ファジーファインダー（VSCode の Quick Open / 全体検索 / コマンドパレット）
--
-- 一覧の中では Ctrl+j / Ctrl+k で上下（VSCode: quickOpenSelectNext / Previous と同じ）
--   Enter : 開く   Ctrl+v : 縦分割で開く   Ctrl+x : 横分割で開く   Ctrl+q : quickfix へ送る

local function builtin(name, opts)
  return function() require("telescope.builtin")[name](opts or {}) end
end

return {
  "nvim-telescope/telescope.nvim",
  cmd = "Telescope",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  keys = {
    -- ファイル
    { "<C-p>", builtin("find_files"), desc = "ファイルを開く (cmd+p)" },
    { "<leader>ff", builtin("find_files"), desc = "ファイルを開く" },
    { "<leader>fa", builtin("find_files", { hidden = true, no_ignore = true }), desc = "ファイルを開く（gitignore 含む）" },
    { "<leader>fr", builtin("oldfiles", { only_cwd = true }), desc = "最近開いたファイル" },
    { "<leader>fb", builtin("buffers", { sort_mru = true }), desc = "開いているバッファ" },
    { "<leader><leader>", builtin("buffers", { sort_mru = true }), desc = "開いているバッファ" },
    -- 検索（VSCode: cmd+shift+f）
    { "<leader>sg", builtin("live_grep"), desc = "プロジェクト全体を grep" },
    { "<leader>/", builtin("live_grep"), desc = "プロジェクト全体を grep" },
    { "<leader>sa", builtin("live_grep", { additional_args = { "--hidden", "--no-ignore" } }), desc = "grep（gitignore 含む）" },
    { "<leader>sw", builtin("grep_string"), mode = { "n", "x" }, desc = "カーソル下の単語 / 選択範囲を grep" },
    { "<leader>sb", builtin("current_buffer_fuzzy_find"), desc = "このファイル内を検索" },
    -- その他（VSCode: cmd+shift+p / alt+, → openGlobalKeybindings）
    { "<leader>sc", builtin("commands"), desc = "コマンドパレット" },
    { "<leader>sk", builtin("keymaps"), desc = "キーマップ一覧" },
    { "<leader>sh", builtin("help_tags"), desc = "ヘルプ" },
    { "<leader>sd", builtin("diagnostics"), desc = "診断（問題）一覧" },
    { "<leader>ss", builtin("lsp_document_symbols"), desc = "シンボル（cmd+shift+o）" },
    { "<leader>sS", builtin("lsp_dynamic_workspace_symbols"), desc = "ワークスペースのシンボル（cmd+t）" },
    { "<leader>sr", builtin("resume"), desc = "前回の検索を再開" },
    { "<leader>gc", builtin("git_commits"), desc = "Git コミット一覧" },
    { "<leader>gb", builtin("git_branches"), desc = "Git ブランチ" },
  },
  opts = function()
    local actions = require("telescope.actions")
    return {
      defaults = {
        prompt_prefix = "  ",
        selection_caret = " ",
        sorting_strategy = "ascending",
        layout_config = { prompt_position = "top", horizontal = { preview_width = 0.55 } },
        path_display = { "filename_first" },
        file_ignore_patterns = { "^.git/", "node_modules/" },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<Esc>"] = actions.close,
          },
        },
      },
      pickers = {
        find_files = { hidden = true },
      },
    }
  end,
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    pcall(telescope.load_extension, "fzf")
  end,
}
