" ~/.vimrc -> dotfiles/vim/.vimrc
" メインのエディタは Neovim（dotfiles/nvim）。
" これはプラグインなしの素の Vim 用（サーバーや nvim がない環境での最低限の設定）。
" キー操作は nvim/lua/config/keymaps.lua と揃えてある。

set nocompatible
filetype plugin indent on
syntax on

let mapleader = "\<Space>"

" 表示
set number relativenumber
set signcolumn=yes
set nowrap
set scrolloff=5
set laststatus=2
set showcmd
set list listchars=tab:»\ ,trail:·
set splitright splitbelow
set wildmenu wildmode=longest:full,full

" インデント
set expandtab tabstop=2 shiftwidth=2 softtabstop=2 shiftround smartindent

" 検索
set ignorecase smartcase incsearch hlsearch

" ファイル / 編集
set encoding=utf-8 fileencodings=utf-8,cp932
set fixendofline
set noswapfile
set autoread
set hidden
set backspace=indent,eol,start
set virtualedit=block
set whichwrap+=<,>,[,],h,l
set clipboard=unnamed
set belloff=all
set ttimeoutlen=10
if has('persistent_undo')
  set undodir=~/.vim/undo undofile
  silent! call mkdir(expand('~/.vim/undo'), 'p')
endif

" --- キーマップ ---------------------------------------------------------------
nnoremap <silent> <Esc><Esc> :nohlsearch<CR>
nnoremap <C-s> :write<CR>
inoremap <C-s> <Esc>:write<CR>
nnoremap <leader>w :write<CR>
nnoremap <leader>qq :quitall<CR>

" ウィンドウ移動
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" 挿入モードのカーソル移動
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>

" バッファ切り替え
nnoremap <S-h> :bprevious<CR>
nnoremap <S-l> :bnext<CR>
nnoremap <leader>bd :bdelete<CR>

" ビジュアルモードのインデントで選択を保つ
xnoremap < <gv
xnoremap > >gv

" ファイルを開く / 探す（:find は path 以下を再帰的に探す）
set path=.,**
nnoremap <leader>ff :find<Space>
nnoremap <leader>e :Explore<CR>

" 保存時に行末の空白を削除
augroup my_vimrc
  autocmd!
  autocmd BufWritePre * if &filetype !=# 'markdown' | let s:v = winsaveview() | keeppatterns %s/\s\+$//e | call winrestview(s:v) | endif
augroup END
