call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

Plug 'sickill/vim-pasta'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-surround'

" Completions and diagnosis {{{
" Still too much trouble involving pyenv and system python for YCM auto
" recompile post-update, just do that manually!
Plug 'Valloric/YouCompleteMe'
Plug 'scrooloose/syntastic'
Plug 'tmux-plugins/vim-tmux'
Plug 'tpope/vim-eunuch'
Plug 'vim-scripts/restore_view.vim'
Plug 'hackel/vis'
Plug 'tpope/vim-fugitive'
Plug 'majutsushi/tagbar'
Plug 'craigemery/vim-autotag'
Plug 'davidhalter/jedi-vim'
" }}}

call plug#end()

set runtimepath^=~/.vim/bundle/ctrlp.vim

set background=dark
colorscheme darkblue

set completeopt=longest,menuone
set expandtab
set encoding=utf8
set hlsearch
set ignorecase
set smartcase
set incsearch
set mouse=nvc
set number
set ruler
set scrolloff=10
set shiftwidth=2
set noshiftround
set showcmd
set smartindent
set softtabstop=2
set tabstop=2
set t_Co=256
set viewoptions=cursor,folds,slash,unix
set virtualedit=block
set visualbell t_vb=
set wildmenu
set wildignore=*.o,*.so,*.swp,*~,*.pyc

"--------------------------------------------------------------------
" Colors {{{
highlight Folded ctermfg=243 ctermbg=234 guifg=Cyan guibg=DarkGrey
highlight FoldColumn ctermbg=234 guifg=Cyan guibg=Grey
" Custom auto-complete menu colors
highlight PmenuSel ctermfg=white ctermbg=20
highlight Pmenu ctermfg=252 ctermbg=17
highlight Normal ctermbg=none
highlight ColorColumn ctermbg=53
" }}}


"--------------------------------------------------------------------
" Status line {{{
highlight StatusLine cterm=none ctermbg=235
highlight StatusLineNC cterm=none ctermbg=233
highlight Status1C ctermfg=blue ctermbg=235
highlight Status2C ctermfg=red ctermbg=235
highlight Status3C ctermfg=yellow ctermbg=235
highlight Status4C ctermfg=green ctermbg=235
highlight Status1NC ctermfg=darkgray ctermbg=233
highlight Status2NC ctermfg=124 ctermbg=233
highlight Status3NC ctermfg=100 ctermbg=233
highlight Status4NC ctermfg=70 ctermbg=233
set laststatus=2
function! SetHighlight(nr)
  for i in [1,2,3,4]
    if (winnr() == a:nr)
      exec 'highlight! link Status'.i.' Status'.i.'C'
    else
      exec 'highlight! link Status'.i.' Status'.i.'NC'
    endif
  endfor
  return ''
endfunction
function! BuildStatusLine(nr)
  return '%{SetHighlight(' . a:nr . ')}' .
        \ '%=%#Status1#%F %#Status2#[%{&encoding}/%{&fileformat}/%Y]%#Status3# %l,%c %#Status4#%4P '
endfunction
set statusline=%!BuildStatusLine(winnr())
" }}}

" Custom keybinding {{{
" Trying space as leader key, need to be careful not conflict with fzf
" bindings.
let mapleader="\<Space>"
let maplocalleader="\<Space>"
set pastetoggle=<F2>
" }}}

" Autocmds {{{
augroup MyAutoCmd
  autocmd!
augroup END
autocmd MyAutoCmd BufWritePost .vimrc nested source $MYVIMRC
" }}}

"
"--------------------------------------------------------------------
" Misc utilities {{{
" Move swap/undo files. {{{
" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .
if isdirectory($HOME . '/.vim/swap') == 0
  :silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

if exists("+undofile")
  " undofile - This allows you to use undos after exiting and restarting
  " This, like swap and backups, uses .vim-undo first, then ~/.vim/undo,
  " then .
  " :help undo-persistence
  " This is only present in 7.3+
  if isdirectory($HOME . '/.vim/undo') == 0
    :silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
  endif
  set undodir=./.vim-undo//
  set undodir+=~/.vim/undo//
  set undodir+=.
  set undofile
endif

" }}}


" NERDTree {{{

" Settings {{{
let NERDTreeWinSize=24
let NERDTreeIgnore=['\.o$', '\.a$', '\.d$', '\.pyc', '\.swo', '\.swp', '\.un\~', '\.un', '\.git$[[dir]]']
" }}}

" Mappings {{{
nnoremap <S-Tab> :NERDTreeToggle<CR>
nnoremap <Leader>n :NERDTreeFind<CR>:wincmd p<CR>
" }}}

" Autocmds {{{
" Close vim if the only window open is nerdtree
autocmd MyAutoCmd BufEnter *
      \ if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
" }}}


" NERDCommenter {{{
" Settings {{{
let g:NERDSpaceDelims=1
let g:NERDDefaultAlign='left'
" }}}
" }}}
" }}}

" fzf {{{
" Settings {{{
let g:fzf_command_prefix = 'FZF'
let g:fzf_action = {
      \ 'ctrl-t': 'tab split',
      \ 'ctrl-x': 'botright split',
      \ 'ctrl-v': 'botright vsplit' }
command! -bang -nargs=* FZFRg
  \ call fzf#vim#grep(
  \   'rg --no-heading --vimgrep --colors path:style:bold --colors path:fg:blue'.
  \   ' --colors line:style:bold --colors line:fg:black --colors match:fg:green'.
  \   ' --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview('up:60%')
  \           : fzf#vim#with_preview('right:50%:hidden', '?'),
  \   <bang>0)
" }}}
" Mappings {{{
nnoremap <Leader>h :FZFHistory<CR>
nnoremap <Leader>c :FZFCommands<CR>
nnoremap <Leader><Space> :FZF<CR>
nnoremap <Leader>g :FZFAg<CR>
nnoremap <Leader>l :FZFBLines<CR>
nnoremap <Leader>rg :FZFRg <C-R><C-W><CR>
nnoremap <Leader>s :FZFLines<CR>
nnoremap <Leader>; :FZFHistory:<CR>
nnoremap <Leader>r :FZFRg <C-R><C-W><CR>
" }}}
" }}}

" vim-eunuch {{{
" Mappings {{{
cnoremap w!! SudoWrite
" }}}
" }}}

nnoremap <silent> <Leader>b :TagbarToggle<CR>

function! s:tags_sink(line)
  let parts = split(a:line, '\t\zs')
  let excmd = matchstr(parts[2:], '^.*\ze;"\t')
  execute 'silent e' parts[1][:-2]
  let [magic, &magic] = [&magic, 0]
  execute excmd
  let &magic = magic
endfunction

function! s:tags()
  if empty(tagfiles())
    echohl WarningMsg
    echom 'Preparing tags'
    echohl None
    call system('ctags -R')
  endif

  call fzf#run({
  \ 'source':  'cat '.join(map(tagfiles(), 'fnamemodify(v:val, ":S")')).
  \            '| grep -v -a ^!',
  \ 'options': '+m -d "\t" --with-nth 1,4.. -n 1 --tiebreak=index',
  \ 'down':    '40%',
  \ 'sink':    function('s:tags_sink')})
endfunction

command! Tags call s:tags()

map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

let g:ackprg = 'ag --nogroup --nocolor --column'

nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>
