-- プラグインに依存しないキーマップ
-- プラグインのキーマップは各 lua/plugins/*.lua の `keys` に、LSP のキーマップは lua/plugins/lsp.lua に置いている。
--
-- 方針: Vim 標準の操作（hjkl / w b e / d c y / . / u など）は上書きしない。
--       VSCode で自分で割り当てていたキーのうち、ターミナルで受け取れるものだけ同じキーで再現する。
--       （cmd キーはターミナルの Neovim には届かないので <leader> に置き換えている）

local map = vim.keymap.set

-- 検索ハイライトを Esc で消す
map("n", "<Esc>", "<cmd>nohlsearch<cr><Esc>")

-- 保存 / 終了（VSCode: cmd+s / cmd+w 相当）
map({ "n", "i", "x" }, "<C-s>", "<cmd>write<cr><Esc>", { desc = "保存" })
map("n", "<leader>w", "<cmd>write<cr>", { desc = "保存" })
map("n", "<leader>qq", "<cmd>quitall<cr>", { desc = "すべて閉じて終了" })

-- ウィンドウ（分割）間の移動: Ctrl + hjkl
map("n", "<C-h>", "<C-w>h", { desc = "左のウィンドウへ" })
map("n", "<C-j>", "<C-w>j", { desc = "下のウィンドウへ" })
map("n", "<C-k>", "<C-w>k", { desc = "上のウィンドウへ" })
map("n", "<C-l>", "<C-w>l", { desc = "右のウィンドウへ" })
map("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "縦に分割" })
map("n", "<leader>-", "<cmd>split<cr>", { desc = "横に分割" })

-- 挿入モードのカーソル移動: Ctrl + hjkl（VSCode: ctrl+h/j/k/l → cursorLeft/Down/Up/Right）
map("i", "<C-h>", "<Left>", { desc = "左へ" })
map("i", "<C-j>", "<Down>", { desc = "下へ" })
map("i", "<C-k>", "<Up>", { desc = "上へ" })
map("i", "<C-l>", "<Right>", { desc = "右へ" })

-- 表示行で上下移動（折り返し行でも自然に動く。カウント付きなら実際の行）
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- バッファ（VSCode のタブ）の切り替え
-- VSCode: ctrl+m / ctrl+, → previousEditor / nextEditor
-- ※ ターミナルでは Ctrl+m は Enter と区別できないので Shift+h / Shift+l を基本にする
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "前のバッファ" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "次のバッファ" })
map("n", "<C-,>", "<cmd>bnext<cr>", { desc = "次のバッファ" }) -- 端末が Ctrl+, を送れる場合のみ有効

-- VSCode: shift+cmd+w → closeUnmodifiedEditors（未変更のバッファをすべて閉じる）
map("n", "<leader>bu", function()
  local cur = vim.api.nvim_get_current_buf()
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if b ~= cur and vim.bo[b].buflisted and not vim.bo[b].modified then
      vim.api.nvim_buf_delete(b, {})
    end
  end
end, { desc = "未変更のバッファを閉じる" })

-- 行の移動 / 複製（VSCode: alt+j/k → moveLines, shift+alt+j/k → copyLines）
-- ※ iTerm2 は Profiles > Keys で Option キーを「Esc+」にしておく必要がある
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "行を下へ移動" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "行を上へ移動" })
map("i", "<A-j>", "<Esc><cmd>move .+1<cr>==gi", { desc = "行を下へ移動" })
map("i", "<A-k>", "<Esc><cmd>move .-2<cr>==gi", { desc = "行を上へ移動" })
map("x", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "選択行を下へ移動" })
map("x", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "選択行を上へ移動" })
map("n", "<A-J>", "<cmd>copy .<cr>", { desc = "行を下に複製" })
map("n", "<A-K>", "<cmd>copy .-1<cr>", { desc = "行を上に複製" })
map("x", "<A-J>", ":copy '><cr>gv", { desc = "選択行を下に複製" })
map("x", "<A-K>", ":copy '<-1<cr>gv", { desc = "選択行を上に複製" })

-- インデント（VSCode: ctrl+] / ctrl+[）
-- Ctrl+[ は Esc そのものなので割り当てられない。Vim 標準の >> / << / ビジュアルの > < を使う。
-- ビジュアルモードでは選択を保ったまま続けてインデントできるようにする
map("x", "<", "<gv")
map("x", ">", ">gv")

-- コメントのトグル（VSCode: ctrl+/）。Vim 標準は gcc（行） / gc{motion} / ビジュアルで gc
-- ターミナルは Ctrl+/ を Ctrl+_ として送ってくるので両方に割り当てる
for _, key in ipairs({ "<C-/>", "<C-_>" }) do
  map("n", key, "gcc", { remap = true, desc = "コメントをトグル" })
  map("x", key, "gc", { remap = true, desc = "コメントをトグル" })
  map("i", key, "<Esc>gcca", { remap = true, desc = "コメントをトグル" })
end

-- 戻る（VSCode: ctrl+shift+enter → navigateBack）。Vim 標準は Ctrl+o（戻る） / Ctrl+i（進む）
map("n", "<C-S-CR>", "<C-o>", { desc = "前の位置へ戻る" })

-- ファイルパスのコピー（VSCode: ctrl+c → copyRelativeFilePath）
local function copy_path(modifier)
  return function()
    local path = vim.fn.expand("%" .. modifier)
    vim.fn.setreg("+", path)
    vim.notify("Copied: " .. path)
  end
end
map("n", "<C-c>", copy_path(":."), { desc = "相対パスをコピー" })
map("n", "<leader>cp", copy_path(":."), { desc = "相対パスをコピー" })
map("n", "<leader>cP", copy_path(":p"), { desc = "絶対パスをコピー" })

-- ハイライトグループの確認（VSCode: ctrl+shift+cmd+p → inspectTMScopes）
map("n", "<leader>ui", "<cmd>Inspect<cr>", { desc = "カーソル位置のハイライトを調べる" })

-- 診断（エラー / 警告）の移動。]d / [d は Vim 標準
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "行の診断を表示" })

-- ターミナルモードから Esc 2回でノーマルモードへ
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "ターミナルからノーマルモードへ" })

-- 置換を楽にする: カーソル下の単語で :%s を開始
map("n", "<leader>sR", [[:%s/\<<C-r><C-w>\>//gc<Left><Left><Left>]], { desc = "カーソル下の単語を置換" })
