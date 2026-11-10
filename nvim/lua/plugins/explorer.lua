-- ファイルエクスプローラ（VSCode のサイドバー）
--
-- 主な操作（エクスプローラ内）
--   l / Enter : 開く・フォルダを展開      h : フォルダを閉じる（VSCode: ctrl+h → list.collapse）
--   P         : プレビュー（フォーカスはツリーのまま。VSCode: space → openFilePreserveFocus）
--   a         : 新規ファイル（末尾に / でフォルダ。VSCode: cmd+n / cmd+d）
--   r : リネーム  d : 削除  c : コピー  m : 移動  y : 名前をコピー
--   H : 隠しファイル表示切替  / : 絞り込み  ? : ヘルプ

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim", "echasnovski/mini.icons" },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle reveal<cr>", desc = "エクスプローラを開閉" },
      { "<leader>E", "<cmd>Neotree focus reveal<cr>", desc = "エクスプローラにフォーカス" },
      { "<leader>ge", "<cmd>Neotree float git_status<cr>", desc = "Git の変更ファイル一覧" },
    },
    init = function()
      -- `nvim .` でディレクトリを開いたときもエクスプローラを出す
      vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("my_neotree_start", { clear = true }),
        once = true,
        callback = function()
          local arg = vim.fn.argv(0)
          if arg ~= "" and vim.fn.isdirectory(arg) == 1 then require("neo-tree") end
        end,
      })
    end,
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      sources = { "filesystem", "git_status", "buffers" },
      filesystem = {
        follow_current_file = { enabled = true },  -- 開いているファイルをツリーで追う
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = "open_default", -- `nvim .` でもサイドバーとして開く（Space e で閉じられる）
        filtered_items = {
          visible = true,           -- 隠しファイルも薄く表示（search.useIgnoreFiles: false に合わせる）
          hide_dotfiles = false,
          hide_gitignored = false,
          never_show = { ".DS_Store" },
        },
      },
      window = {
        width = 32,
        mappings = {
          ["<space>"] = "none", -- Space は <leader> として使う
          ["l"] = "open",
          ["h"] = "close_node",
          ["P"] = { "toggle_preview", config = { use_float = false } },
          ["Y"] = {
            function(state)
              local path = vim.fn.fnamemodify(state.tree:get_node():get_id(), ":.")
              vim.fn.setreg("+", path)
              vim.notify("Copied: " .. path)
            end,
            desc = "相対パスをコピー",
          },
        },
      },
      default_component_configs = {
        git_status = { symbols = { unstaged = "M", staged = "S", untracked = "U", ignored = "", conflict = "!" } },
      },
    },
  },

  -- エクスプローラでファイルを移動 / リネームしたら import を書き換える
  -- （VSCode: js/ts.updateImportsOnFileMove.enabled: always）
  {
    "antosha417/nvim-lsp-file-operations",
    event = "LspAttach",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-neo-tree/neo-tree.nvim" },
    opts = {},
  },
}
