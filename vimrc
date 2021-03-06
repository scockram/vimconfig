" Means all addons/themes etc are bundled nicer.
call pathogen#runtime_append_all_bundles() 
call pathogen#helptags()

""" BACKEND
set nocompatible

set history=700
" Turn this off before on - Debian turns it on before pathogen is loaded, so
" pathogen doesn't load correctly.
filetype off
filetype plugin on
filetype indent on

" Lazy
autocmd! bufwritepost vimrc source ~/.vimrc

" This is pretty non standard
set nobackup
set nowritebackup
set noswapfile
set backupdir=~/.vim/backups
set directory=~/.vim/tmp

let mapleader = ","
let g:mapleader = ","

""" USER INTERFACE
set so=7 " vertical scrolling sensible
set hid " Buffer changing
set ruler " Current position
set cmdheight=1 " Commandbar height
set backspace=indent,start " backspace config
set wildmenu " Use statusbar for list of tab completions. (For not omni complete things)
set cursorline

" Search related things
set ignorecase
set smartcase
set hlsearch
set incsearch
map <F7> :noh<cr>

" For showing matching braces when caret over them
set showmatch 
set mat=5 " for how long...

" Beeps are annoying
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" tabs and indents
set expandtab
set tabstop=2
set shiftwidth=2
set lbr
set tw=80
set ai " indent
set si " indent
set wrap

""" HANDY Mappings
map ; :

noremap ;; ;
noremap ,, ,

""" COLORS AND STUFF
syntax enable
set nu
set showtabline=0

set background=dark

if has("gui_running")
  set guifont=Inconsolata\ 12
  set guioptions= " No GUI stuff
  colorscheme Monokai
else
  set background=dark
  "let g:solarized_termcolors=256
  "let g:solarized_italic=0
  "let g:solarized_degrade=1
  "let g:solarized_termtrans=0
  "colorscheme solarized
  colorscheme Monokai
endif

" Fast switching of background.
map <F6> :let &background = ( &background == "dark"? "light" : "dark" )<CR>



""" SANE BUFFERS AND TABS
" Smart way to move btw. windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" When pressing <leader>cd switch to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>

" Move around the buffers the same way we close them
map <leader>bn :bn<cr>
map <leader>bp :bp<cr>

map <C-S-tab> :bp<cr>
map <C-tab> :bn<cr>

" Close all the buffers
map <leader>ba :1,300 bd!<cr>

" Use the arrows to something usefull
"map <right> :bn<cr>
"map <left> :bp<cr>

" as above
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
   let l:currentBufNum = bufnr("%")
   let l:alternateBufNum = bufnr("#")

   if buflisted(l:alternateBufNum)
     buffer #
   else
     bnext
   endif

   if bufnr("%") == l:currentBufNum
     new
   endif

   if buflisted(l:currentBufNum)
     execute("bdelete! ".l:currentBufNum)
   endif
endfunction

""" MiniBufExplorer
let g:miniBufExplModSelTarget = 1
let g:miniBufExplorerMoreThanOne = 2
let g:miniBufExplModSelTarget = 0
let g:miniBufExplUseSingleClick = 1
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplSplitBelow=0

autocmd BufRead,BufNew :call UMiniBufExplorer
map <leader>u :TMiniBufExplorer<cr>

""" Indents
" ,ig and similar...


""" Statusline
" Always show the statusline
set laststatus=2

" Format the statusline
set statusline=\ %{HasPaste()}%f%m%r%y\ \ \ CWD:%r%{CurDir()}%h%=%c:%l/%L\ [%P]

function! CurDir()
    let curdir = substitute(getcwd(), '/home/steve', "~", "g")
    return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction

hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black
hi Modified guibg=orange guifg=black ctermbg=lightred ctermfg=black

function! MyStatusLine(mode)
    let statusline=""
    if a:mode == 'Enter'
        let statusline.="%#StatColor#"
    endif
    let statusline.="\(%n\)\ %f\ "
    if a:mode == 'Enter'
        let statusline.="%*"
    endif
    let statusline.="%#Modified#%m"
    if a:mode == 'Leave'
        let statusline.="%*%r"
    elseif a:mode == 'Enter'
        let statusline.="%r%*"
    endif
    let statusline .= "\ (%l/%L,\ %c)\ %P%=%h%w\ %y\ [%{&encoding}:%{&fileformat}]\ \ "
    return statusline
endfunction

au WinEnter * setlocal statusline=%!MyStatusLine('Enter')
au WinLeave * setlocal statusline=%!MyStatusLine('Leave')
set statusline=%!MyStatusLine('Enter')

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi StatColor guibg=orange ctermbg=lightred
  elseif a:mode == 'r'
    hi StatColor guibg=#e454ba ctermbg=magenta
  elseif a:mode == 'v'
    hi StatColor guibg=#e454ba ctermbg=magenta
  else
    hi StatColor guibg=red ctermbg=red
  endif
endfunction 

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi StatColor guibg=#95e454 guifg=black ctermbg=lightgreen ctermfg=black

cmap w!! %!sudo tee > /dev/null %

