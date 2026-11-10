-- シンタックスハイライト / インデント / 構文単位のテキストオブジェクト
--
-- nvim-treesitter は Neovim 0.12 対応の main ブランチを使う。
-- main ブランチはパーサーのインストールだけを担当し、ハイライトは Neovim 本体の vim.treesitter.start() で有効にする。
-- パーサーのビルドに tree-sitter CLI が必要（brew install tree-sitter-cli）。

local parsers = {
  "bash", "css", "diff", "embedded_template", "html", "javascript", "json", "lua", "luadoc",
  "markdown", "markdown_inline", "python", "query", "regex", "ruby", "rust", "scss", "terraform",
  "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main ブランチは遅延読み込み非対応
    build = ":TSUpdate",
    config = function()
      local ts = require("nvim-treesitter")
      ts.install(parsers) -- 未インストールのものだけ非同期で入れる

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("my_treesitter", { clear = true }),
        callback = function(ev)
          local lang = vim.treesitter.language.get_lang(ev.match)
          if not lang then return end
          -- 一覧にない言語は開いた時に自動でインストール
          if not vim.tbl_contains(ts.get_installed(), lang) then
            if vim.tbl_contains(ts.get_available(), lang) then ts.install(lang) end
            return
          end
          if not pcall(vim.treesitter.start, ev.buf, lang) then return end
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },

  -- 関数 / クラス単位の操作: vaf（関数を選択） dif（関数の中身を削除） ]f [f（関数へ移動）
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    init = function()
      vim.g.no_plugin_maps = true -- 言語ごとの標準 ftplugin のキーマップと衝突させない
    end,
    config = function()
      require("nvim-treesitter-textobjects").setup({ select = { lookahead = true } })
      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local objects = {
        af = "@function.outer", ["if"] = "@function.inner",
        ac = "@class.outer", ic = "@class.inner",
        aa = "@parameter.outer", ia = "@parameter.inner",
      }
      for lhs, query in pairs(objects) do
        vim.keymap.set({ "x", "o" }, lhs, function() select.select_textobject(query, "textobjects") end,
          { desc = query })
      end
      vim.keymap.set({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer", "textobjects") end,
        { desc = "次の関数へ" })
      vim.keymap.set({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer", "textobjects") end,
        { desc = "前の関数へ" })
    end,
  },

  -- スクロールしても今いる関数 / クラスの行を上に固定表示（VSCode の Sticky Scroll）
  { "nvim-treesitter/nvim-treesitter-context", event = { "BufReadPost", "BufNewFile" }, opts = { max_lines = 3 } },

  -- HTML / JSX の閉じタグを自動で入れる・リネームする
  { "windwp/nvim-ts-autotag", event = { "BufReadPost", "BufNewFile" }, opts = {} },
}
