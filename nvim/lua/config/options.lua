-- エディタの基本オプション
-- 右端のコメントは対応する VSCode の settings.json の項目

local opt = vim.opt

-- 表示
opt.number = true            -- 行番号
opt.relativenumber = true    -- 相対行番号（5j / 3k のような移動がしやすくなる）
opt.signcolumn = "yes"       -- git / 診断の目印用の列を常に確保（ガタつき防止）
opt.cursorline = false       -- editor.lineHighlightBackground: 透明
opt.wrap = false             -- editor.wordWrap: off
opt.scrolloff = 5            -- カーソルの上下に最低5行を残してスクロール
opt.sidescrolloff = 8
opt.termguicolors = true
opt.list = true              -- タブと行末空白を可視化
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.showmode = false         -- モードは lualine に表示する
opt.laststatus = 3           -- ステータスラインはウィンドウ全体で1本
opt.cmdheight = 1
opt.pumheight = 12
opt.splitright = true        -- 縦分割は右に、横分割は下に開く（VSCode と同じ感覚）
opt.splitbelow = true
opt.fillchars = { eob = " " } -- バッファ末尾の ~ を消す
opt.mouse = "a"
opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor"

-- インデント
opt.expandtab = true         -- タブの代わりにスペース
opt.tabstop = 2              -- editor.tabSize: 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.shiftround = true
opt.smartindent = true
opt.breakindent = true

-- 検索
opt.ignorecase = true        -- 小文字だけなら大文字小文字を区別しない
opt.smartcase = true         -- 大文字を含むなら区別する
opt.inccommand = "split"     -- :%s/// の置換結果をプレビュー

-- ファイル
opt.fileencodings = { "utf-8", "cp932" }
opt.fixendofline = true      -- files.insertFinalNewline: true
opt.undofile = true          -- 閉じても undo 履歴を残す
opt.swapfile = false         -- files.autoSave があるので swap は不要
opt.autoread = true          -- 外部で変更されたら読み直す（git checkout 後など）
opt.confirm = true           -- 未保存で :q したら確認を出す

-- 編集
opt.clipboard = "unnamedplus" -- ヤンク / 削除を macOS のクリップボードと共有
opt.virtualedit = "block"    -- 矩形選択で文字がない所まで進める
opt.whichwrap:append("<,>,[,],h,l") -- 行頭 / 行末で h / l したら前後の行へ
opt.updatetime = 250         -- CursorHold / gitsigns の反応速度
opt.timeoutlen = 400         -- <leader> の後に which-key が出るまでの時間
opt.completeopt = { "menu", "menuone", "noselect" }
opt.shortmess:append("c")
