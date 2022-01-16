filetype off                   " required!

set guicursor=

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

Plug 'Lokaltog/powerline'
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'ryanoasis/vim-devicons'
Plug 'mileszs/ack.vim'
Plug 'jakar/vim-json'
Plug 'prettier/vim-prettier'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' " install ripgrep for :Rg to work https://archlinux.org/packages/community/x86_64/ripgrep/

" Typescript-related plugins

if has('nvim')
  Plug 'mhartington/nvim-typescript', {'do': './install.sh'}
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }
else
  Plug 'Shougo/denite.nvim'
  Plug 'Shougo/deoplete.nvim'
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
endif

call plug#end()

" Wrap in try/catch to avoid errors on initial install before plugin is available
try
" === Denite setup ==="
" Use ripgrep for searching current directory for files
" By default, ripgrep will respect rules in .gitignore
"   --files: Print each file that would be searched (but don't search)
"   --glob:  Include or exclues files for searching that match the given glob
"            (aka ignore .git files)
"
call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])

" Use ripgrep in place of "grep"
call denite#custom#var('grep', 'command', ['rg'])

" Custom options for ripgrep
"   --vimgrep:  Show results with every match on it's own line
"   --hidden:   Search hidden directories and files
"   --heading:  Show the file name above clusters of matches from each file
"   --S:        Search case insensitively if the pattern is all lowercase
call denite#custom#var('grep', 'default_opts', ['--hidden', '--vimgrep', '--heading', '-S'])

" Recommended defaults for ripgrep via Denite docs
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

" Remove date from buffer list
call denite#custom#var('buffer', 'date_format', '')

" Custom options for Denite
"   auto_resize             - Auto resize the Denite window height automatically.
"   prompt                  - Customize denite prompt
"   direction               - Specify Denite window direction as directly below current pane
"   winminheight            - Specify min height for Denite window
"   highlight_mode_insert   - Specify h1-CursorLine in insert mode
"   prompt_highlight        - Specify color of prompt
"   highlight_matched_char  - Matched characters highlight
"   highlight_matched_range - matched range highlight
let s:denite_options = {'default' : {
\ 'split': 'floating',
\ 'start_filter': 1,
\ 'auto_resize': 1,
\ 'source_names': 'short',
\ 'prompt': 'λ ',
\ 'highlight_matched_char': 'QuickFixLine',
\ 'highlight_matched_range': 'Visual',
\ 'highlight_window_background': 'Visual',
\ 'highlight_filter_background': 'DiffAdd',
\ 'winrow': 1,
\ 'vertical_preview': 1
\ }}

" Loop through denite options and enable them
function! s:profile(opts) abort
  for l:fname in keys(a:opts)
    for l:dopt in keys(a:opts[l:fname])
      call denite#custom#option(l:fname, l:dopt, a:opts[l:fname][l:dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)
catch
  echo 'Denite not installed. It should work after running :PlugInstall'
endtry




" === Denite shorcuts === "
"   ;         - Browser currently open buffers
"   <leader>t - Browse list of files in current directory
"   <leader>g - Search current directory for occurences of given term and close window if no results
"   <leader>j - Search current directory for occurences of word under cursor
nmap ; :Denite buffer<CR>
nmap <leader>t :DeniteProjectDir file/rec<CR>
nnoremap <leader>g :<C-u>Denite grep:. -no-empty<CR>
nnoremap <leader>j :<C-u>DeniteCursorWord grep:.<CR>

" Define mappings while in 'filter' mode
"   <C-o>         - Switch to normal mode inside of search results
"   <Esc>         - Exit denite window in any mode
"   <CR>          - Open currently selected file in any mode
"   <C-t>         - Open currently selected file in a new tab
"   <C-v>         - Open currently selected file a vertical split
"   <C-h>         - Open currently selected file in a horizontal split
autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
  imap <silent><buffer> <C-o>
  \ <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  inoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  inoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  inoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  inoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction

" Define mappings while in denite window
"   <CR>        - Opens currently selected file
"   q or <Esc>  - Quit Denite window
"   d           - Delete currenly selected file
"   p           - Preview currently selected file
"   <C-o> or i  - Switch to insert mode inside of filter prompt
"   <C-t>       - Open currently selected file in a new tab
"   <C-v>       - Open currently selected file a vertical split
"   <C-h>       - Open currently selected file in a horizontal split
autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> <Esc>
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-o>
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <C-t>
  \ denite#do_map('do_action', 'tabopen')
  nnoremap <silent><buffer><expr> <C-v>
  \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> <C-h>
  \ denite#do_map('do_action', 'split')
endfunction

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


set splitbelow
set splitright


nnoremap ,d :NERDTreeToggle<cr>

nnoremap ,f :Files<cr>

highlight ColorColumn ctermbg=0 guibg=lightgrey

command! FormatJSON %!python -m json.tool 

