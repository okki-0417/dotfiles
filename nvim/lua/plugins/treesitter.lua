-- シンタックスハイライト / インデント / 構文単位のテキストオブジェクト

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSUpdate" },
    dependencies = { "nvim-treesitter/nvim-treesitter-textobjects" },
    main = "nvim-treesitter.configs",
    opts = {
      ensure_installed = {
        "bash", "css", "diff", "embedded_template", "html", "javascript", "json", "jsonc", "lua", "luadoc",
        "markdown", "markdown_inline", "python", "query", "regex", "ruby", "rust", "scss", "terraform", "toml", "tsx",
        "typescript", "vim", "vimdoc", "yaml",
      },
      auto_install = true,
      highlight = { enable = true },
      indent = { enable = true },
      -- Ctrl+Space で構文単位に選択範囲を広げる（VSCode: shift+ctrl+→ の Expand Selection）
      incremental_selection = {
        enable = true,
        keymaps = { init_selection = "<C-space>", node_incremental = "<C-space>", node_decremental = "<BS>" },
      },
      -- 関数 / クラス単位の操作: vaf（関数を選択） dif（関数の中身を削除） ]f [f（関数へ移動）
      textobjects = {
        select = {
          enable = true,
          lookahead = true,
          keymaps = {
            ["af"] = "@function.outer", ["if"] = "@function.inner",
            ["ac"] = "@class.outer", ["ic"] = "@class.inner",
            ["aa"] = "@parameter.outer", ["ia"] = "@parameter.inner",
          },
        },
        move = {
          enable = true,
          goto_next_start = { ["]f"] = "@function.outer" },
          goto_previous_start = { ["[f"] = "@function.outer" },
        },
      },
    },
  },

  -- スクロールしても今いる関数 / クラスの行を上に固定表示（VSCode の Sticky Scroll）
  { "nvim-treesitter/nvim-treesitter-context", event = { "BufReadPost", "BufNewFile" }, opts = { max_lines = 3 } },

  -- HTML / JSX の閉じタグを自動で入れる・リネームする
  { "windwp/nvim-ts-autotag", event = { "BufReadPost", "BufNewFile" }, opts = {} },
}
