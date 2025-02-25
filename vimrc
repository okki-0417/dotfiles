set nocompatible

let s:dein_base = '/Users/mumumu/.cache/dein'
let s:dein_src = '/Users/mumumu/.cache/dein/repos/github.com/Shougo/dein.vim'

execute 'set runtimepath+=' . s:dein_src

set number	" 行番号を表示
" vim の矩形選択で文字が無くても右へ進める
set virtualedit=block
" 挿入モードでバックスペースで削除できるようにする
set backspace=indent,eol,start
"タブ文字の代わりにスペースを使う(切り替え)
set smartindent
"Tabキーで挿入するスペースの数(数値)
set softtabstop=2
"カレントディレクトリを自動で移動
set autochdir
"バッファ内で扱う文字コード(文字列)
set encoding=utf-8
"読み込む文字コード(文字列のリスト) : この場合UTF-8を試し、だめならShift_JIS
set fileencodings=utf-8,cp932
" エラーメッセージの表示時にビープを鳴らさない
set noerrorbells
" 対応する括弧やブレースを表示
set showmatch matchtime=1
" メッセージ表示欄を2行確保
set cmdheight=2
" ステータス行を常に表示
set laststatus=2
" 行末のスペースを可視化
set listchars=tab:^\ ,trail:~
" コマンドラインの履歴を10000件保存する
set history=10000
" 入力モードでTabキー押下時に半角スペースを挿入
set expandtab
" yでコピーした時にクリップボードに入る
set guioptions+=a
" メニューバーを非表示にする
set guioptions-=m
" 対応する括弧を強調表示
set showmatch
" タイトルを表示
set title
" ヤンクでクリップボードにコピー
set clipboard=unnamed,autoselect
" 行をまたいで移動
set whichwrap=b,s,h,l,<,>,[,],~

call dein#begin(s:dein_base)

call dein#add(s:dein_src)
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('preservim/nerdtree')
call dein#add('rafamadriz/neon')
call dein#add('tpope/vim-fugitive')     " Git操作
call dein#add('junegunn/fzf', { 'build': './install --all' })   " ファジー検索
call dein#add('junegunn/fzf.vim')   " ファジー検索
call dein#add('prabirshrestha/vim-lsp')   " 言語サポートのサーバーをインストール
call dein#add('mattn/vim-lsp-settings')   " 言語サポートのサーバーをインストール
call dein#add('neoclide/coc.nvim', {'branch': 'release'})   " cocで非同期で補完を表示
call dein#add('dense-analysis/ale')
call dein#add('fholgado/minibufexpl.vim')

call dein#end()

syntax on

set termguicolors
let g:neon_style = "dark"  " より暗めのバージョン
colorscheme neon

" 補完ウィンドウの操作
inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" 定義元にジャンプ
nnoremap <silent> gd <Plug>(coc-definition)

" 参照元を検索
nnoremap <silent> gr <Plug>(coc-references)

" コードのリネーム
nnoremap <silent> <Leader>rn <Plug>(coc-rename)

" コードフォーマット
nnoremap <silent> <Leader>f :call CocAction('format')<CR>

" 診断情報を表示
nnoremap <silent> <Leader>d :CocDiagnostics<CR>

" 保存ショートカット
nnoremap <C-s> :w<CR>
nnoremap <C-q> :q<CR>
inoremap <C-s> <Esc>:w<CR>a

" ウィンドウ操作の簡略化
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k

" ファイル検索
nnoremap <C-p> :Files<CR>

" NERDTreeをトグルするショートカット
nnoremap <C-n> :NERDTreeToggle<CR>
autocmd VimEnter * NERDTree

" minibufexpl
nnoremap <C-m> :bp<CR>
nnoremap <C-,> :bn<CR>

if dein#check_install()
 call dein#install()
endif
