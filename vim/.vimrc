filetype off                   " required!

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


call plug#begin()

Plug 'Lokaltog/powerline'
Plug 'scrooloose/nerdcommenter'
Plug 'chrisbra/csv.vim'
Plug 'github/copilot.vim'

" Theme
Plug 'morhetz/gruvbox'

Plug 'nvim-tree/nvim-web-devicons' " optional, for file icons
Plug 'nvim-tree/nvim-tree.lua'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' 

Plug 'neoclide/coc.nvim' , { 'branch' : 'release' }

Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }

Plug 'joshuavial/aider.nvim'

" Swift stuff
Plug 'keith/swift.vim'
Plug 'mhartington/formatter.nvim'
call plug#end()

lua require('local')

lua require('aider').setup({ auto_manage_context = false, default_bindings = false })

" Copilot stuff from Jake's set up
let g:copilot_no_tab_map = v:true
let g:copilot_assume_mapped = v:true
imap <silent><script><expr> <C-y> copilot#Accept('\<CR>')
let g:copilot_no_tab_map = v:true


let g:coc_global_extensions = [ 'coc-tsserver' ]

filetype plugin indent on

set mouse=nicr
set cursorline
set splitbelow
set splitright

let g:autoclose_on = 0

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
let NERDSpaceDelims=1
vmap ++ <plug>NERDCommenterToggle
nmap ++ <plug>NERDCommenterToggle

"vmap ++ gc
"nmap ++ gcc

nnoremap ,d :NvimTreeToggle<cr>
nnoremap ,n :NvimTreeFindFile<cr>

" vim-prettier
"let g:prettier#quickfix_enabled = 0
"let g:prettier#quickfix_auto_focus = 0
" prettier command for coc
command! -nargs=0 Prettier :CocCommand prettier.formatFile
" run prettier on save


"""""""""
" COC Setup
"""""""""


" mostly copy pasta from https://github.com/neoclide/coc.nvim

" coc config
let g:coc_global_extensions = [
  \ 'coc-tsserver',
  \ 'coc-prettier',
  \ 'coc-pyright',
  \ 'coc-json',
  \ 'coc-eslint',
  \ ]


" from readme
" if hidden is not set, TextEdit might fail.
set hidden " Some servers have issues with backup files, see #649 set nobackup set nowritebackup " Better display for messages set cmdheight=2 " You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1):
            \ <SID>check_back_space() ? "\<Tab>" :
            \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"


" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <F2> <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
" nmap <silent> <C-d> <Plug>(coc-range-select)
" xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

""""""""""""
" END OF COC SETUP
""""""""""""



" All operations work with the OS clipboard
set clipboard=unnamed

set directory=~/.vim/tmp

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
set termencoding=utf8
set hidden



" Buffers listed
set bl

colo gruvbox

set ic
set scs

set encoding=utf-8
set mousehide
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

" map %% to the current directory if we doing a ':' Ex command
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" C-c and C-v - Copy/Paste to global clipboard
vmap <C-C> "+yi
imap <C-V> <esc>"+gPi

imap <S-Insert> <esc>"+gPi

let $FZF_DEFAULT_COMMAND = 'rg --files --hidden'
nnoremap <C-P> :Files<CR>

" F3 - list of buffers
nmap <F3> :Buffers<cr>
vmap <F3> <esc>:Buffers<cr>
imap <F3> <esc>:Buffers<cr>

vmap < <gv
vmap > >gv

" Включаем filetype плугин. Настройки, специфичные для определынных файлов мы разнесём по разным местам
filetype plugin on

"""""
" vimrc -- shortcut and reloading on change
"
nmap ,v :e ~/.vimrc<CR>
autocmd! bufwritepost ~/.vimrc source ~/.config/nvim/init.vim

set noerrorbells
set visualbell
set t_vb=

" set langmap=АБЦДЕФГХИЙКЛМНОПЯРСТУЖВЬЪЗ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,абцдефгхийклмнопярстужвьъз;abcdefghijklmnopqrstuvwxyz
" set keymap=bulgarian-phonetic
" set iminsert=0 imsearch=-1


set splitbelow
set splitright


nnoremap ,f :GFiles --cached --others --exclude-standard<cr>
nnoremap ,r :Rg<cr>

command! FormatJSON %!python3 -m json.tool 

" Escape from terminal insert mode into normal via Esc
" Having it bound to just Esc messes up :Rg and :GFiles
if has('nvim')
    tnoremap <C-v><Esc> <C-\><C-n>
endif
