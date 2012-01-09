" wipple's vimrc

" Beginning{{{
" スクリプトエンコーディング
scriptencoding utf-8
" ハイライトを有効に
syntax enable
" 最初に設定上書き
filetype plugin on
filetype indent on
" 非公開設定
if filereadable(expand('~/.vimrc.local'))
    exe 'source' expand('~/.vimrc.local')
endif
" MyAutoCmd定義
augroup vimrc
    autocmd!
augroup END
command! -bang -nargs=* MyAutoCmd autocmd<bang> vimrc <args>
"}}}

" General setting{{{

" KeyMaps {{{
" マップリーダー
let mapleader = 'm'
" Tabキーで編集ファイルのディレクトリに移動
nnoremap <Tab> :<C-u>lcd %:h<CR>
" インサートモードを抜けたときにカーソルを右に移動
inoremap <Esc> <Esc><Right>
" Emacs キーバインド
inoremap <C-b> <Left>
inoremap <C-d> <Del>
inoremap <C-f> <Right>
" カーソルジャンプ後に画面スクロール
nnoremap n nzz
nnoremap N Nzz
nnoremap * g*zz
nnoremap # g#zz
nnoremap g* *zz
nnoremap g# #zz
nnoremap G Gzz
" タブ関係
nnoremap tt :<C-u>tabnew<CR>
nnoremap <Space> :<C-u>tabnext<CR>
nnoremap <S-Space> :<C-u>tabNext<CR>

" ;が押しやすいので
noremap ; :
" h<Spase>で縦分割でヘルプ表示
cnoremap h<Space> vert h<Space>
"}}}

" Tabline {{{
set stal=2
set tabline=%!MyTabLine()
function! MyTabLine()
    let s = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
        let buflist = tabpagebuflist(i)
        let winnr = tabpagewinnr(i)
        let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
        let s .= '%' . i . 'T'
        let s .= ' [' . i . '] '
        let file = bufname(buflist[winnr - 1])
        let file = fnamemodify(file, ':p:t')
        if file == ''
            let file = '[No Name]'
        endif
        let s .= file
        if i == t
            let s .= '%m'
        endif
        let s .= ' '
        let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    return s
endfunction
"}}}

" Statsline {{{
" 常にステータスラインを表示
set laststatus=2
" バッファ番号/トータルバッファ数
set stl=[%n/%{bufnr('$')}]
" 収まり切らない場合切り詰める
set stl+=%<
" ファイル名
set stl+=\ %f
" ファイルエンコーディング
set stl+=\ [%{(&fenc!=''?&fenc:&enc)}
" ファイルフォーマット（unix/dos/mac）
set stl+=:%{&ff}
" ファイルタイプ
set stl+=:%Y]
" 左寄せ項目と右寄せ項目の区切り
set stl+=%=
" 行,列
set stl+=\ %1l/%L,%c
" ファイル内の何％の位置にあるか
set stl+=\ %P
"}}}

" Charset {{{
" Vimの通常使う文字エンコーディング
set enc=utf-8
" ターミナルで使われるエンコーディング
set tenc=utf-8
" 対応するファイルタイプ
if has('guess_encode')
    set fencs=ucs-bom,iso-2022-jp,guess,euc-jp,cp932
else
    set fencs=ucs-bom,iso-2022-jp,euc-jp,cp932
endif
" LF, CRLF, CR
set ffs=unix,dos,mac
" マルチバイトでのカーソル位置の調整
set ambiwidth=double
" migemo
set migemo
let migemodict=$HOME.'.vim/dict/migemo-dict'
"}}}

" File {{{
" バックアップファイルの保存先
set backupdir=$HOME/backup
" スワップファイルの保存先
let &directory = &backupdir
" Undo履歴ファイルの保存先
if has('persistent_undo')
    let &undodir = &backupdir
    set undofile
endif
" 外部の操作（gitなど）による変更を自動更新
set autoread
" 編集中に他のファイルを開く
set hidden
" カーソル位置の復元
MyAutoCmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
"}}}

" Edit {{{
" オートインデント、スマートインデント
set autoindent smartindent smarttab
" オートインデント、タブのスペース幅
set shiftwidth=4 tabstop=4
" <Tab>でスペース入力、CTRL-V<Tab>でタブ入力
set expandtab
" バックスペースで削除
set backspace=indent,eol,start
" 自動折り返しフォーマットオプション
MyAutoCmd FileType * set fo-=cro fo+=M
" 編集モードで折り返さない
set textwidth=0
" クリップボードにコピー
set clipboard=unnamed
" コマンド履歴
set history=200
" コマンドライン補完強化
set wildmenu
" 保存時に行末の空白、タブを除去
MyAutoCmd BufWritePre * :%s/[ \t]\+$//ge
"}}}

" Search {{{
" 大文字小文字無視
set ignorecase
" 大文字ではじめたら大文字小文字無視しない
set smartcase
" インクリメンタルサーチ
set incsearch
" 検索文字ハイライトを無効に
set nohlsearch
" 最後まで検索した後に先頭に戻らない
set nowrapscan
"}}}

" Looks {{{
" ターミナルで256色表示
set t_Co=256
" 長文を折り返す
set wrap
" 行番号を表示
set number
" 不可視文字表示
set list lcs=eol:$,tab:>_
" 括弧の対応をハイライト
set showmatch
" 入力中のコマンドを表示
set showcmd
" 現在のモードを表示
set showmode
" コマンドラインの高さ
set cmdheight=1
" j,kでページめくり
set scrolloff=99
" 印字不可能文字を16進数で表示
set display=uhex
" 分割したら新しいウィンドウは右・下に
set splitbelow splitright
"}}}

" Programming {{{
" オムニ補完
MyAutoCmd FileType * if &l:omnifunc == '' | setlocal omnifunc=syntaxcomplete#Complete | endif
" 補完設定
set completeopt=menuone,preview
" タグファイル
set tags=./tags,tags
" Javaのハイライト
let java_highlight_all = 1
" 新しいバージョンのDosBatchに対応
let dosbatch_cmdextversion = 1
" Pythonのハイライト
let python_highlight_all = 1
" ShellScriptの誤判定防止
let sh_minlines = 500
"}}}

"}}}

" Plugin setting{{{

" Plugin Manager{{{
" NeoBundle {{{
if has('vim_starting')
    set runtimepath+=$HOME/.vim/bundle/neobundle.vim
    filetype off
    call neobundle#rc(expand('$HOME/.vim/bundle'))
    filetype plugin on
    filetype indent on
endif
NeoBundle 'Shougo/neobundle.vim'
"}}}
"}}}

" Libraries {{{
" vimproc{{{
NeoBundle 'Shougo/vimproc'
"}}}
" openbuf{{{
NeoBundle 'thinca/vim-openbuf'
"}}}
" open-browser{{{
NeoBundle 'tyru/open-browser.vim'
let g:netrw_nogx = 1
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
"}}}
" webapi{{{
NeoBundle 'git@github.com:wipple/webapi-vim.git'
" 勝手に追加したsocks5サポート
" 特に理由がなければ環境変数の設定で'HTTP_PROXY=socks5://host:port/'で十分
let g:webapi_socks_host = 'localhost'
let g:webapi_socks_port = 1080
"}}}
" vimdoc-ja{{{
NeoBundle 'vim-jp/vimdoc-ja'
"}}}
"}}}

" Unite {{{
" Unite ソース
NeoBundle 'Shougo/unite.vim'
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'thinca/vim-unite-history'
NeoBundle 'choplin/unite-vim_hacks'
NeoBundle 'mattn/unite-advent_calendar'
NeoBundle 'git@github.com:wipple/unite-qf.git'
" 基本的に縦分割
let g:unite_enable_split_vertically = 1
" NeoBundleのために横は大きめにとる
let g:unite_winwidth = 85
" Uniteのハイライトの設定
let g:unite_cursor_line_highlight = 'PmenuSel'
let g:unite_abbr_highlight = 'Normal'
" 日時表示はなるべく短く
let g:unite_source_file_mru_time_format = "%Y/%m/%d %H:%M "
" ファイル名表示フォーマット指定を空にして高速化
let g:unite_source_file_mru_filename_format = ''
" インサートモードでUnite開始
let g:unite_enable_start_insert = 1
" 候補更新間隔（ミリ秒）
let g:unite_update_time = 200
" 最近使用したファイルの最大保存件数
let g:unite_source_file_mru_limit = 200
" ディレクトリのブックマークをVimFilerで開く
call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')
" Uniteキーマップ
" プレフィックス
nnoremap [unite] <Nop>
xnoremap [unite] <Nop>
nmap f [unite]
xmap f [unite]
" Uniteソース一覧
nnoremap <silent> [unite]u :<C-u>Unite source<CR>
" バッファ一覧
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
" 編集ファイルのあるディレクトリの一覧
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" ブックマーク一覧
nnoremap <silent> [unite]k :<C-u>Unite bookmark<CR>
" 最近使用したファイル一覧
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
" レジスタ一覧
nnoremap <silent> [unite]r :<C-u>Unite -buffer-name=register register<CR>
" Uniteアウトライン
nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
" コマンド履歴一覧
nnoremap <silent> [unite]h :<C-u>Unite history/command:<CR>
" Unite grepの起動
nnoremap <silent> [unite]g :<C-u>Unite grep<CR>
" NeoBundleをUniteから起動（必要なら'!'を入力し、最後にリターン入力）
nnoremap [unite]n :<C-u>Unite neobundle/install:
" Ctrl-Dキーで一気に終了
MyAutoCmd FileType unite imap <silent><buffer> <C-d> <Plug>(unite_exit)
" 縦分割で開く（ソースによっては非対応）
MyAutoCmd FileType unite inoremap <silent><buffer><expr> <C-j> unite#do_action('vsplit')
"}}}

" Utilities {{{
" vimshell{{{
NeoBundle 'Shougo/vimshell'
" インサートモードでの自動更新のタイミング
let g:vimshell_interactive_update_time = 10
" vimshellのコマンド履歴の最大保存数
let g:vimshell_max_command_history = 9999
" 基本的に縦分割
let g:vimshell_split_command = 'vsplit'
" ユーザープロンプト
let g:vimshell_user_prompt = 'fnamemodify(getcwd(), ":~")'
" 右プロンプト
let g:vimshell_right_prompt = 'strftime("%H:%M:%S")'
" 大文字開始の場合caseを区別
let g:vimshell_smart_case = 1
" キーマップ
nnoremap <silent> vs :<C-u>VimShellPop<CR>
" Ctrl-Dで一気に終了
MyAutoCmd FileType vimshell imap <buffer> <C-d> <Plug>(vimshell_exit)
" ディレクトリ移動したときに自動で`ls -aF`
MyAutoCmd FileType vimshell call vimshell#hook#add('chpwd', 'my_chpwd', 'g:my_chpwd')
function! g:my_chpwd(args, context)
    call vimshell#execute('ls -aF')
endfunction
"}}}
" vimfiler{{{
NeoBundle 'Shougo/vimfiler'
" デフォルトのファイラーに
let g:vimfiler_as_default_explorer = 1
" ファイル削除などを可能に
let g:vimfiler_safe_mode_by_default = 0
" 日時表示はなるべく短く
let g:vimfiler_time_format = "%y/%m/%d %H:%M"
" データ保存場所
let g:vimfiler_data_directory = $HOME."/.vimfiler"
" 表示設定
let g:vimfiler_tree_leaf_icon = ' '
let g:vimfiler_tree_opened_icon = '▾'
let g:vimfiler_tree_closed_icon = '▸'
let g:vimfiler_file_icon = '-'
let g:vimfiler_marked_file_icon = '*'
" システムのデフォルトの関連付けで開く
call vimfiler#set_execute_file('bmp,jpg,png,gif,pdf', 'open')
" キーマップ
nnoremap <silent> vf :<C-u>VimFilerSplit<CR>
"}}}
" vim-ref{{{
NeoBundle 'thinca/vim-ref'
" 基本的に縦分割
let g:ref_open = 'vsplit'
" vimproc使用
let g:ref_use_vimproc = 1
" alc関係の設定
let g:ref_alc_use_cache = 1
let g:ref_alc_start_linenumber = 40
" キーマップ
nnoremap <silent> <Leader>a :<C-u>call ref#jump('normal', 'alc')<CR><C-d>
vnoremap <silent> <Leader>a :<C-u>call ref#jump('visual', 'alc')<CR><C-d>
MyAutoCmd FileType ref call s:initialize_ref_viewer()
function! s:initialize_ref_viewer()
    " 戻る
    nmap <buffer> b <Plug>(ref-back)
    " 進む
    nmap <buffer> f <Plug>(ref-forward)
    " 終わる
    nnoremap <buffer> q <C-w>c
    setlocal nonumber
endfunction
"}}}
" QFixHowm{{{
NeoBundle 'fuenor/qfixhowm'
" QFixHowm関連の設定を無効に
let QFixHowm_Convert = 0
" マップリーダー設定
let qfixmemo_mapleader = ','
" 外部grep使用
let mygrepprg='grep'
" ファイルフォーマット関係
let qfixmemo_fileencoding = 'utf-8'
let qfixmemo_fileformat = 'unix'
let qfixmemo_filetype = ''
" octopressと連携
let qfixmemo_dir = '$HOME/src/octopress/source/_posts'
let QFixMRU_RootDir = '$HOME/src/octopress/source/_posts'
let QFixMRU_Filename = '$HOME/.qfixmru'
let qfixmemo_timeformat = 'date: %Y-%m-%d %H:%M'
let qfixmemo_filename = '%Y-%m-%d-%H%M.mkd'
let qfixmemo_template =
            \ ['---', 'layout: post', '%TITLE% ', '%DATE%',
            \ 'comments: true', 'categories: ', '---']
let qfixmemo_title = 'title:'
let qfixmemo_timeformat_regxp = '^date: \d\{4}-\d\{2}-\d\{2} \d\{2}:\d\{2}'
let qfixmemo_timestamp_regxp = qfixmemo_timeformat_regxp
let qfixmemo_template_keycmd = "2j$a"
let QFixMRU_Title = {}
let QFixMRU_Title['mkd'] = '^title:'
" 自動整形
let qfixmemo_use_keyword = 0
let qfixmemo_use_addtitle = 0
let qfixmemo_use_addtime = 0
let qfixmemo_use_updatetime = 1
let qfixmemo_use_deletenulllines = 0
nnoremap <Leader>b :<C-u>!rake gen_deploy<CR>
"}}}
" lightdiff {{{
NeoBundle 'git@github.com:wipple/lightdiff.git'
colorscheme lightdiff
"}}}
"}}}

" Programming {{{
" neocomplcache{{{
NeoBundle 'Shougo/neocomplcache'
" 起動時に有効に
let g:neocomplcache_enable_at_startup = 1
" スマート補完
let g:neocomplcache_enable_smart_case = 1
" 3文字目から補完
let g:neocomplcache_min_syntax_length = 3
" 自動補完を無効化するバッファ名
let g:neocomplcache_lock_buffer_name_pattern = '*ku*'
" 辞書
let g:neocomplcache_dictionary_filetype_lists = {
            \ 'vimshell': $HOME.'/.vimshell/command-history',
            \ 'c': $HOME.'.vim/dict/c.dict',
            \ 'cpp': $HOME.'.vim/dict/cpp.dict',
            \ 'vim': $HOME.'.vim/dict/vim.dict',
            \ }
" オムニ補完
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
" キーマップ
imap <C-k> <Plug>(neocomplcache_snippets_expand)
smap <C-k> <Plug>(neocomplcache_snippets_expand)
inoremap <expr><C-g> neocomplcache#undo_completion()
inoremap <expr><C-l> neocomplcache#complete_common_string()
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><CR>  pumvisible() ? neocomplcache#close_popup() : "\<CR>"
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y> neocomplcache#close_popup()
inoremap <expr><C-e> neocomplcache#cancel_popup()
" conceal設定
if has('conceal')
    set conceallevel=2
    set concealcursor=i
endif
"}}}
" neco-look{{{
NeoBundle 'git@github.com:wipple/neco-look.git'
" lookコマンドに辞書ファイルの引数を渡せるように勝手に改造
let g:neocomplcache_source_look_dictionaries = ['/usr/share/dict/*']
"}}}
" git-vim{{{
NeoBundle 'motemen/git-vim'
" デフォルトのキーマップを無効にしていくつか追加
let g:git_no_map_default = 1
nnoremap ga :GitAdd<CR>
nnoremap gA :GitAdd <cfile><CR>
nnoremap gb :GitBlame<CR>
nnoremap gc :GitCommit<CR>
nnoremap gC :GitCommit --amend -C HEAD<CR>
nnoremap gd :GitDiff<CR>
nnoremap gD :GitDiff --cached<CR>
nnoremap gl :GitLog<CR>
nnoremap gm :GitVimDiffMerge<CR>
nnoremap gM :GitVimDiffMergeDone<CR>
nnoremap gs :GitStatus<CR>
nnoremap gp :GitPullRebase<CR>
nnoremap gP :GitPush<CR>
"}}}
" taglist{{{
NeoBundle 'taglist.vim'
" 自ビルドのctagsを使用
let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'
" 複数のファイルを開くとかさばるので
let Tlist_Show_One_File = 1
" 左側は色々表示するので右側に表示
let Tlist_Use_Right_Window = 1
" コンパクトに表示
let Tlist_Compact_Format = 1
" ファイルを閉じたら自動で閉じる
let Tlist_Exit_OnlyWindow = 1
" 非アクティブの場合自動でフォールド
let Tlist_File_Fold_Auto_Close = 1
" キーマップ
nnoremap <silent> <Leader>t :<C-u>TlistToggle<CR>
"}}}
" project{{{
NeoBundle 'project.tar.gz'
nnoremap <silent> <Leader>p :<C-u>Project<CR>
"}}}
" caw{{{
NeoBundle 'tyru/caw.vim'
nmap <Leader>c <Plug>(caw:prefix)
vmap <Leader>c <Plug>(caw:prefix)
nmap <Plug>(caw:prefix)<Space> <Plug>(caw:i:toggle)
vmap <Plug>(caw:prefix)<Space> <Plug>(caw:i:toggle)
"}}}
" alignta{{{
NeoBundle 'h1mesuke/vim-alignta'
let g:unite_source_alignta_preset_arguments = [
            \ ["Align at '='", '=>\='],
            \ ["Align at ':'", '01 :'],
            \ ["Align at '|'", '|'   ],
            \ ["Align at ')'", '0 )' ],
            \ ["Align at ']'", '0 ]' ],
            \ ["Align at '}'", '}'   ],
            \]
let s:comment_leadings = '^\s*\("\|#\|/\*\|//\|<!--\)'
let g:unite_source_alignta_preset_options = [
            \ ["Justify Left",      '<<' ],
            \ ["Justify Center",    '||' ],
            \ ["Justify Right",     '>>' ],
            \ ["Justify None",      '==' ],
            \ ["Shift Left",        '<-' ],
            \ ["Shift Right",       '->' ],
            \ ["Shift Left  [Tab]", '<--'],
            \ ["Shift Right [Tab]", '-->'],
            \ ["Margin 0:0",        '0'  ],
            \ ["Margin 0:1",        '01' ],
            \ ["Margin 1:0",        '10' ],
            \ ["Margin 1:1",        '1'  ],
            \
            \ 'v/' . s:comment_leadings,
            \ 'g/' . s:comment_leadings,
            \]
unlet s:comment_leadings
nnoremap <silent> [unite]a :<C-u>Unite alignta:options<CR>
xnoremap <silent> [unite]a :<C-u>Unite alignta:arguments<CR>
"}}}
" surround{{{
NeoBundle 'kana/vim-surround'
"}}}
" quickrun{{{
NeoBundle 'thinca/vim-quickrun'
"}}}
"}}}

" Internet {{{
" gist-vim{{{
NeoBundle 'mattn/gist-vim'
" 基本的に非公開
let g:gist_private = 1
" 非公開ファイルもリストに表示
let g:gist_show_privates = 1
" 投稿後にプレビュー
let g:gist_open_browser_after_post = 1
" プレビューの際のコマンド
let g:gist_browser_command = ':vne | setl bt=nofile | sil r !w3m -dump %URL%'
" 投稿後にURLをクリップボードにコピー
let g:gist_clip_command = 'pbcopy'
" ファイルタイプ特定
let g:gist_detect_filetype = 1
"}}}
" googlereader-vim{{{
NeoBundle 'git@github.com:wipple/googlereader-vim.git'
nnoremap <silent> <Leader>g :<C-u>GoogleReader<CR>
"}}}
" TweetVim{{{
NeoBundle 'basyura/TweetVim'
NeoBundle 'basyura/twibill.vim'
let g:tweetvim_include_rts = 1
" neocomplcacheと連携
if !exists('g:neocomplcache_dictionary_filetype_lists')
    let g:neocomplcache_dictionary_filetype_lists = {}
endif
let neco_dic = g:neocomplcache_dictionary_filetype_lists
let neco_dic.tweetvim_say = $HOME . '/.tweetvim/screen_name'
" キーマップ
nnoremap <silent> ft :<C-u>Unite tweetvim<CR>
nnoremap <silent> th :<C-u>TweetVimHomeTimeline<CR>
nnoremap <silent> ts :<C-u>TweetVimSay<CR>
nnoremap <silent> tm :<C-u>TweetVimMentions<CR>
"}}}
" chalice{{{
NeoBundle 'koron/chalice'
let chalice_anonyname = ""
let chalice_usermail = "sage"
let chalice_foldmarks = '●○'
let chalice_statusline = '%c,'
let chalice_startupflags = 'bookmark'
let chalice_writeoptions = 'amp,nbsp,zenkaku'
let chalice_preview = 0
let chalice_titlestring = "2ch"
"}}}
" vimplenote{{{
NeoBundle 'mattn/vimplenote-vim'
"}}}
" lingr{{{
NeoBundle 'tsukkee/lingr-vim'
"}}}
"}}}

"}}}

" Ends {{{
set secure
"}}}

" vim:set ft=vim foldmethod=marker:
