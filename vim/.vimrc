filetype off                   " required!


" Updates
set rtp+=~/.vim/bundle/vundle
call vundle#rc('$HOME/.vim/bundle/')

Bundle 'gmarik/vundle'
Bundle 'git://git.wincent.com/command-t.git'
Bundle 'kien/ctrlp.vim.git'

Bundle 'vim-scripts/minibufexplorerpp.git'
Bundle 'vim-scripts/vcscommand.vim.git'
Bundle 'vim-scripts/vim-coffee-script.git'
Bundle 'tpope/vim-rails.git'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-fugitive.git'
Bundle 'tpope/vim-haml.git'
Bundle 'itspriddle/vim-jquery.git'
Bundle 'mineiro/vim-latex.git'
Bundle 'Lokaltog/vim-powerline.git'
Bundle 'Lokaltog/vim-easymotion.git'
Bundle 'pangloss/vim-javascript.git'
Bundle 'felixge/vim-nodejs-errorformat.git'
Bundle 'duff/vim-scratch.git'
Bundle 'danro/rename.vim.git'
Bundle 'scrooloose/nerdcommenter.git'
Bundle 'maksimr/vim-jsbeautify.git'
Bundle 'vim-scripts/jshint.vim.git'
Bundle 'scrooloose/syntastic.git'
Bundle 'majutsushi/tagbar.git'
Bundle 'kien/ctrlp.vim.git'
Bundle 'duff/vim-bufonly.git'
Bundle 'leafgarland/typescript-vim.git'
Bundle 'groenewege/vim-less.git'
Bundle 'goldfeld/vim-seek.git'
Bundle 'mattn/zencoding-vim.git'
Bundle 'vim-scripts/BufClose.vim.git'
Bundle 'vim-scripts/vimwiki.git'
Bundle 'tpope/vim-unimpaired.git'
Bundle 'heavenshell/vim-jsdoc.git'
Bundle 'kana/vim-textobj-user'
Bundle 'kana/vim-textobj-entire'
Bundle 'mileszs/ack.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'leafgarland/typescript-vim'
" Bundle 'marijnh/tern_for_vim'
Bundle 'jakar/vim-json'


filetype plugin indent on

set directory+=,~/tmp

" highlight OverLength ctermbg=red ctermfg=white guibg=#592929
" au BufWinEnter * let w:m2=matchadd('OverLength', '\%>81v.\+', -1)

" au GUIEnter * simalt ~x

"-------------------------
" Базовые настройки
"-------------------------

" Включаем несовместимость настроек с Vi (ибо Vi нам и не понадобится).
set nocompatible

" Показывать положение курсора всё время.
set ruler

" Показывать незавершённые команды в статусбаре
set showcmd

" Включаем нумерацию строк
set nu

" Фолдинг по отсупам
" set foldmethod=syntax

" Поиск по набору текста (очень полезная функция)
set incsearch

" Отключаем подстветку найденных вариантов, и так всё видно.
set nohlsearch

" Теперь нет необходимости передвигать курсор к краю экрана, чтобы подняться в режиме редактирования
set scrolljump=7

" Теперь нет необходимости передвигать курсор к краю экрана, чтобы опуститься в режиме редактирования
set scrolloff=7

" Выключаем надоедливый "звонок"
set novisualbell
set t_vb=

" Поддержка мыши
" set mouse=a
" set mousemodel=popup

" Кодировка текста по умолчанию
set termencoding=utf8

" Не выгружать буфер, когда переключаемся на другой
" Это позволяет редактировать несколько файлов в один и тот же момент без необходимости сохранения каждый раз
" когда переключаешься между ними
set hidden

" Скрыть панель в gui версии ибо она не нужна
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

" Влючить подстветку синтаксиса
syntax on

" allow to use backspace instead of "x"
set backspace=indent,eol,start whichwrap+=<,>,[,]

" Преобразование Таба в пробелы
set expandtab

" Размер табулации по умолчанию
set softtabstop=4
set tabstop=4
set shiftwidth=4

" Формат строки состояния
set statusline=%<%f%h%m%r\ %b\ %{&encoding}\ 0x\ \ %l,%c%V\ %P
set laststatus=2

" Включаем "умные" отспупы ( например, автоотступ после {)
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


let $JS_CMD='node'
autocmd filetype javascript map <F9> :JSHint<cr>
autocmd filetype javascript vmap <F9> <esc>:JSHint<cr>i
autocmd filetype javascript imap <F9> <esc>:JSHint<cr>i

" S-F9 - "make clean"
map <S-F9> :make clean<cr>
vmap <S-F9> <esc>:make clean<cr>i
imap <S-F9> <esc>:make clean<cr>i

autocmd filetype javascript map <S-F9> :ccl<cr>
autocmd filetype javascript vmap <S-F9> <esc>:ccl<cr>i
autocmd filetype javascript imap <S-F9> <esc>:ccl<cr>i

" F10 - удалить буфер
map <F10> :BufClose<cr>
vmap <F10> <esc>:BufClose<cr>
imap <F10> <esc>:BufClose<cr>

" F11 - показать окно Taglist
map <F11> :TlistToggle<cr>
vmap <F11> <esc>:TlistToggle<cr>
imap <F11> <esc>:TlistToggle<cr>

" F12 - обозреватель файлов
map <F12> :Ex<cr>
vmap <F12> <esc>:Ex<cr>i
imap <F12> <esc>:Ex<cr>i

map <F8> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
imap <F8> <ESC>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>a
imap <C-E> <end>

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
"""""""""""""
" functions "
"""""""""""""


""""""""""""""""""""""
" C++ stuff

autocmd FileType c set omnifunc=ccomplete#Complete

" Add highlighting for function definition in C++
function! EnhanceSyntax()
    syn match cppFuncDef "::\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?"
    syn match cppFuncDef "\~\?\zs\h\w*\ze([^)]*\()\s*\(const\)\?\)\?[\s\t\n]*{"
    syn match cppClassDef "class \zs\w*\ze[\s\t\n]*{"
    syn match cppClassDef "\zs\h\w*\ze::"
"    hi def link cppFuncDef Function
"     hi def link cppFuncDef Identifier
    hi def link cppFuncDef Function
    hi def link cppClassDef Special
"    hi def link cppClassDef Type
endfunction

function! IncludeGuard()
    let guard = toupper( substitute( substitute( expand( '%' ), '\([^.]*\)\.h', '\1_h', '' ), '/', '_', '' ) )
    call append( '^', '#define ' . guard )
    +
    call append( '^', '#ifndef ' . guard )
    call append( '$', '#endif // ' . guard )
    +
endfunction

" Insert an include guard based on the file name on ,i
nmap ,i :call IncludeGuard()<CR>

"""""""""""""""""

nmap ,t :CommandT<CR>

"""""
" vimrc
nmap ,v :e $MYVIMRC<CR>
autocmd! bufwritepost $MYVIMRC source %

set formatprg=par\ -w80q
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

" let g:syntastic_check_on_open=1
let g:syntastic_json_checkers = ['jsonlint']
au! BufRead,BufNewFile *.json setfiletype json



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


" vimwiki stuff
let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_badsyms = ' '
let g:vimwiki_folding = 1
let g:vimwiki_fold_lists = 1
let g:vimwiki_table_auto_fmt = 1
let g:vimwiki_list_ignore_newline = 0


let g:tern_map_keys = 1
let g:tern_show_argument_hints = 'on_hold'

nmap ,z :e $HOME/Dropbox-personal/Dropbox/vimwiki/feedback.wiki<CR>


autocmd BufReadPost fugitive://* set bufhidden=delete

" Search the current word under the client/ dir
nmap <C-S-G> "zyw:exe "Ack ".expand("<cword>")." client --type js"<CR>
nmap <C-S-H> "zyw:exe "Ack ".expand("<cword>")." server --type js"<CR>


