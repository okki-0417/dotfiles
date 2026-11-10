-- macOS の Option キーを Neovim で使うための対応表
--
-- iTerm2 の Option キーを「Normal」のままにしていると、Option+j は Alt+j ではなく
-- 「∆」という文字としてターミナルに届く（キーボード配列 ABC の場合）。
-- そこで Option+キー で入力される文字そのものにキーを割り当てる。
-- （iTerm2 を Esc+ にしている環境でも動くよう、<A-x> にも同じキーを割り当てる）

local chars = {
  j = "∆",  -- Option+j
  k = "˚",  -- Option+k
  J = "Ô",  -- Option+Shift+j
  K = "\239\163\191", -- Option+Shift+k（Apple ロゴ U+F8FF）
  d = "∂",  -- Option+d
  l = "¬",  -- Option+l
  ["]"] = "‘", -- Option+]
  ["["] = "“", -- Option+[
}

local M = {}

--- Option+key に当たる lhs の一覧を返す（例: M.lhs("j") → { "<A-j>", "∆" }）
---@param key string
---@return string[]
function M.lhs(key)
  local char = assert(chars[key], "option_key: 未定義のキー " .. key)
  return { "<A-" .. key .. ">", char }
end

--- vim.keymap.set と同じ引数で、Option+key に割り当てる
function M.map(mode, key, rhs, opts)
  for _, lhs in ipairs(M.lhs(key)) do
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

return M
