-- カラースキーム
-- VSCode の "Pink Cat Boo" に近づけるため、catppuccin (mocha) に
-- settings.json の workbench.colorCustomizations / tokenColorCustomizations の色を上書きしている

local pink = "#fbb1f3"
local pink_dim = "#6e4f6e" -- #fbb1f370 を暗い背景に重ねた色
local statusbar = "#212330"

return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,
  opts = {
    flavour = "mocha",
    integrations = {
      blink_cmp = true,
      gitsigns = true,
      mason = true,
      neotree = true,
      telescope = { enabled = true },
      which_key = true,
      diffview = true,
    },
    custom_highlights = function(c)
      return {
        Cursor = { fg = c.base, bg = pink },                       -- editorCursor.foreground
        Visual = { bg = pink_dim },                                -- editor.selectionBackground
        Search = { fg = c.base, bg = pink },                       -- editor.findMatchBackground
        IncSearch = { fg = c.base, bg = pink },
        CurSearch = { fg = c.base, bg = pink },
        CursorLine = { bg = "NONE" },                              -- editor.lineHighlightBackground
        CursorLineNr = { fg = pink, bold = true },
        Comment = { fg = "#58b08b", italic = false },              -- tokenColorCustomizations.comments
        ["@comment"] = { link = "Comment" },
        ["@variable.member.ruby"] = { fg = "#9CDCFE" },            -- Ruby のインスタンス変数
        ["@punctuation.delimiter.json"] = { fg = "#ffff00" },      -- punctuation.separator.key-value
        GitSignsAdd = { fg = "#00FF7F" },                          -- editorGutter.addedBackground
        GitSignsChange = { fg = "#00f2ff" },                       -- editorGutter.modifiedBackground
        GitSignsDelete = { fg = "#FF6347" },                       -- editorGutter.deletedBackground
        StatusLine = { bg = statusbar },                           -- statusBar.background
        PmenuSel = { bg = pink_dim, bold = true },                 -- list.activeSelectionBackground
        TelescopeSelection = { bg = pink_dim },
        NeoTreeCursorLine = { bg = pink_dim },
        FloatBorder = { fg = pink },
        WinSeparator = { fg = "#45475a" },
      }
    end,
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
