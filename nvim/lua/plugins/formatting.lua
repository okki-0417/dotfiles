-- フォーマッタ（VSCode の editor.defaultFormatter / editor.formatOnSave）
--
-- 手動保存（:w / Ctrl+s）の時だけフォーマットする。自動保存ではフォーマットしない（VSCode と同じ）。
-- フォーマッタが見つからない言語は LSP のフォーマット機能を使う。

-- settings.json で formatOnSave: true にしていた言語
local format_on_save_ft = {
  typescript = true, typescriptreact = true, javascript = true,
  json = true, jsonc = true, html = true, ruby = true, markdown = true,
}

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    -- VSCode: shift+alt+f（フォーマット） / shift+cmd+s（rubocop.formatAutocorrects）
    { "<leader>cf", function() require("conform").format({ async = true }) end, mode = { "n", "x" }, desc = "フォーマット" },
    { "<leader>uf", function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify("format on save: " .. (vim.g.disable_autoformat and "OFF" or "ON"))
      end, desc = "保存時フォーマットの切り替え" },
  },
  opts = {
    formatters_by_ft = {
      -- oxc.oxc-vscode → oxfmt（プロジェクトの node_modules にあればそれを使う）。無ければ prettier → vtsls
      typescript = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "oxfmt", "prettierd", "prettier", stop_after_first = true },
      ruby = { "rubocop" }, -- rubocop.vscode-rubocop
      lua = { "stylua" },
      -- javascript / json / html / markdown は VSCode 内蔵フォーマッタだったので LSP（vtsls / jsonls / html）に任せる
    },
    formatters = {
      prettier = { require_cwd = true }, -- prettier の設定ファイルがあるプロジェクトでだけ使う
    },
    default_format_opts = { lsp_format = "fallback" },
    format_on_save = function(buf)
      if vim.g.autosaving or vim.g.disable_autoformat then return end
      if not format_on_save_ft[vim.bo[buf].filetype] then return end
      return { timeout_ms = 2000 }
    end,
  },
}
