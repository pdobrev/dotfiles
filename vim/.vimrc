filetype off                   " required!

set rtp+=~/.fzf

set guicursor=

call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-fugitive'
Plug 'Lokaltog/powerline'
Plug 'mxw/vim-jsx'
Plug 'w0rp/ale'

Plug 'scrooloose/nerdtree'
Plug 'mileszs/ack.vim'
Plug 'airblade/vim-gitgutter'
Plug 'jakar/vim-json'
Plug 'dkprice/vim-easygrep'
Plug 'prettier/vim-prettier'

" Typescript-related plugins

if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

" fzf
Plug 'junegunn/fzf.vim'

call plug#end()

let g:deoplete#enable_at_startup = 1

" ALE Stuff
let g:ale_sign_error = '●' " Less aggressive than the default '>>'
let g:ale_sign_warning = '.'
let g:ale_lint_on_enter = 0 " Less distracting when opening a new file
let g:ale_fixers = {
\   'javascript': ['eslint'],
\   'typescript': ['tslint']
\}
let b:ale_linters = {'javascript': ['eslint'], 'typescript': ['tslint']}

filetype plugin indent on

" All operations work with the OS clipboard
set clipboard=unnamed

set directory=~/.vim/tmp

" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" au BufWinEnter * let w:m2=matchadd('OverLength', '\%>81v.\+', -1)

" au GUIEnter * simalt ~x

set lazyredraw          " redraw only when we need to.

set nocompatible
set ruler
set showcmd
set nu
set incsearch
set nohlsearch
set scrolljump=7
set scrolloff=7
set novisualbell
set t_vb=
" set mouse=a
" set mousemodel=popup
set termencoding=utf8
set hidden

set guioptions-=T
set guioptions-=m
set guioptions-=r
set guioptions-=L

" Сделать строку команд высотой в одну строку
set ch=1

" Buffers listed
set bl

"set background=dark
" Хорошие цвета для черного фона

if has("gui_running")
    colo inkpot
    "set guifont=Terminus
    "set guifont=Screen12
else
    colo desert
endif

set ic
set scs

set encoding=utf-8
" Скрывать указатель мыши, когда печатаем
set mousehide

" Включить автоотступы
set autoindent

syntax on

set backspace=indent,eol,start whichwrap+=<,>,[,]

set expandtab

set softtabstop=4
set tabstop=4
set shiftwidth=4

set statusline=%<%f%h%m%r\ %b\ %{&encoding}\ 0x\ \ %l,%c%V\ %P
set laststatus=2

set smartindent

" Fix <Enter> for comment
set fo+=cr

" Опции сесссий
set sessionoptions=curdir,buffers,tabpages

"-------------------------
" Горячие клавишы
"-------------------------

" Пробел в нормальном режиме перелистывает страницы
" nmap <Space> <PageDown>


" map %% to the current directory if we doing a ':' Ex command
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" CTRL-F для omni completion
imap <C-F> <C-X><C-O>

" C-c and C-v - Copy/Paste в "глобальный клипборд"
vmap <C-C> "+yi
imap <C-V> <esc>"+gPi

" Заставляем shift-insert работать как в Xterm
map <S-Insert> <MiddleMouse>

" C-y - удаление текущей строки
nmap <C-y> dd
imap <C-y> <esc>ddi

" C-d - дублирование текущей строки
imap <C-d> <esc>yypi

" C-k - как в имакз'е
nmap <C-k> d$
imap <C-k> <esc>lC

imap <S-Insert> <esc>"+gPi


" Быстрое перевключение между .h и .cpp
nmap ,a :A<cr>

:nmap <F1> :echo<CR>
:imap <F1> <C-o>:echo<CR>


" F2 - быстрое сохранение
nmap <F2> :w<cr>
vmap <F2> <esc>:w<cr>i
imap <F2> <esc>:w<cr>i

" F3 - просмотр ошибок
nmap <F3> :copen<cr>
vmap <F3> <esc>:copen<cr>
imap <F3> <esc>:copen<cr>

" F6 - предыдущий буфер
map <F6> :bp<cr>
vmap <F6> <esc>:bp<cr>i
imap <F6> <esc>:bp<cr>i

" F7 - следующий буфер
map <F7> :bn<cr>
vmap <F7> <esc>:bn<cr>i
imap <F7> <esc>:bn<cr>i

" F9 - "make" команда
map <F9> :make<cr>
vmap <F9> <esc>:make<cr>i
imap <F9> <esc>:make<cr>i

" S-F8 - "make clean"
map <S-F8> :ClearAllCtrlPCaches<cr>
vmap <S-F8> <esc>:ClearAllCtrlPCaches<cr>i
imap <S-F8> <esc>:ClearAllCtrlPCaches<cr>i

" Ctrl-p config
let g:ctrlp_clear_cache_on_exit = 0
if exists("g:ctrl_user_command")
  unlet g:ctrlp_user_command
endif
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*

let $JS_CMD='node'

" S-F9 - "make clean"
map <S-F9> :make clean<cr>
vmap <S-F9> <esc>:make clean<cr>i
imap <S-F9> <esc>:make clean<cr>i

autocmd filetype javascript map <S-F9> :ccl<cr>
autocmd filetype javascript vmap <S-F9> <esc>:ccl<cr>i
autocmd filetype javascript imap <S-F9> <esc>:ccl<cr>i

" < & > - делаем отступы для блоков
vmap < <gv
vmap > >gv

" Выключаем ненавистный режим замены
imap >Ins> <Esc>i

" Control Left - предыдущий буфер
map <A-Left> :bp<cr>
vmap <A-Left> <esc>:bp<cr>i
imap <A-Left> <esc>:bp<cr>i

"" Control Right - следующий буфер
map <A-Right> :bn<cr>
vmap <A-Right> <esc>:bn<cr>i
imap <A-Right> <esc>:bn<cr>i

" Редко когда надо [ без пары =)
" imap [ []<LEFT>
" Аналогично и для {
" imap {<CR> {<CR>}<Esc>0

" С-q - выход из Vim
map <C-Q> <Esc>:qa<cr>


" Автозавершение слов по tab =)
function! InsertTabWrapper()
     let col = col('.') - 1
     if !col || getline('.')[col - 1] !~ '\k'
         return "\<tab>"
     else
         return "\<c-p>"
     endif
endfunction

imap <tab> <c-r>=InsertTabWrapper()<cr>

" Слова откуда будем завершать
set complete=""
" Из текущего буфера
set complete+=.
" Из словаря
set complete+=k
" Из других открытых буферов
set complete+=b
" из тегов
set complete+=t

" Включаем filetype плугин. Настройки, специфичные для определынных файлов мы разнесём по разным местам
filetype plugin on

" Настройки для Tlist (показвать только текущий файл в окне навигации по  коду)

set completeopt+=longest
set mps-=[:]


au BufNewFile,BufRead *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl
au! BufRead,BufNewFile *.haml         setfiletype haml

"autocmd FileType php set omnifunc=phpcomplete#Complete
"

" let g:DisableSpaceBeforeParen=1

" source ~/.vim/kde-devel-vim.vim
let g:SuperTabDefaultCompletionTypeDiscovery = "&omnifunc:<C-X><C-O>,&completefunc:<C-X><C-U>"
"let php_sql_query=1

set wildmode=longest:list:full
set wildmenu

highlight Pmenu guibg=brown gui=bold


"""""
" vimrc
nmap ,v :e $MYVIMRC<CR>
autocmd! bufwritepost $MYVIMRC source %

set noerrorbells
set visualbell
set t_vb=

map  <Esc>[7~ <Home>
map  <Esc>[8~ <End>

imap <Esc>[7~ <Home>
imap <Esc>[8~ <End>


if has("gui_running")
    set guifont=Andale\ Mono:h13
endif

set langmap=АБЦДЕФГХИЙКЛМНОПЯРСТУЖВЬЪЗ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,абцдефгхийклмнопярстужвьъз;abcdefghijklmnopqrstuvwxyz


"""""
" Strip whiteplaces on save
fun! <SID>StripTrailingWhitespaces()
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    call cursor(l, c)
endfun

autocmd FileType c,cpp,javascript,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>StripTrailingWhitespaces()


"""""
" Show visual delimiter at 80
" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" match OverLength /\%81v.\+/
" set cc=80


autocmd BufReadPost fugitive://* set bufhidden=delete
set wildignore+=client-build,tags


"" SPLITS

" Easier split movement
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

set splitbelow
set splitright


nmap <leader>f :FZF<CR>

let s:clang_library_path='/Library/Developer/CommandLineTools/usr/lib'
if isdirectory(s:clang_library_path)
    let g:clang_library_path=s:clang_library_path
endif

nnoremap ,d :NERDTreeToggle<cr>


highlight ColorColumn ctermbg=0 guibg=lightgrey

