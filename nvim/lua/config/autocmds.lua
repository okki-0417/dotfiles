-- 自動コマンド（VSCode の settings.json の挙動を再現するもの）

local function augroup(name)
  return vim.api.nvim_create_augroup("my_" .. name, { clear = true })
end

-- files.trimTrailingWhitespace: true
-- 保存時に行末の空白を削除（markdown は改行の意味があるので除外）
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup("trim_whitespace"),
  callback = function(ev)
    if vim.bo[ev.buf].filetype == "markdown" or not vim.bo[ev.buf].modifiable then return end
    local view = vim.fn.winsaveview()
    vim.cmd([[keeppatterns silent! %s/\s\+$//e]])
    vim.fn.winrestview(view)
  end,
})

-- files.autoSave: afterDelay
-- ノーマルモードに戻って 1 秒経ったら保存する。
-- VSCode と同じく、自動保存ではフォーマットしない（vim.g.autosaving を conform 側で見ている）。
local timers = {}
vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = augroup("autosave"),
  callback = function(ev)
    local buf = ev.buf
    local bo = vim.bo[buf]
    if bo.buftype ~= "" or not bo.modifiable or bo.readonly or vim.api.nvim_buf_get_name(buf) == "" then
      return
    end
    if timers[buf] then timers[buf]:stop() end
    timers[buf] = vim.defer_fn(function()
      timers[buf] = nil
      if not vim.api.nvim_buf_is_valid(buf) or not vim.bo[buf].modified then return end
      if vim.fn.mode() ~= "n" then return end -- 入力中は保存しない
      vim.g.autosaving = true
      vim.api.nvim_buf_call(buf, function() vim.cmd("silent! lockmarks update") end)
      vim.g.autosaving = false
    end, 1000)
  end,
})

-- フォーカスが戻ったら外部の変更を読み込む
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = augroup("checktime"),
  command = "silent! checktime",
})

-- ヤンクした範囲を一瞬ハイライト
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("yank_highlight"),
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

-- 前回閉じた時のカーソル位置から開く
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_position"),
  callback = function(ev)
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lines = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 0 and mark[1] <= lines and vim.bo[ev.buf].filetype ~= "gitcommit" then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- ヘルプや一時バッファは q で閉じる
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = { "help", "qf", "man", "lspinfo", "checkhealth", "notify", "git" },
  callback = function(ev)
    vim.bo[ev.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = ev.buf, silent = true })
  end,
})
