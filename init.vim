cd /SourceTree

"Trying to solve fzf not showing preview properly.
"set shell=cmd.exe
"set shellcmdflag=/c\ doskey\ bash=C:/Progra~1/Git/bin/bash.exe

"set shell=cmd.exe\ /k\ doskey\ bash=C:/Progra~1/Git/bin/bash.exe

"set shellcmdflag=/k\ doskey bash=C:/Progra~1/Git/bin/bash.exe
"set shell=C:\\Progra~1\\Git\\bin\\bash.exe

"set shell=C:/Progra~1/Git/bin/sh.exe
"set shellcmdflag=-c
"set shellxquote=\"

" Terminal settings
":tnoremap <C-[> <C-\><C-n>
"if has("win32")
"  " Note, you need to empty the file Git\etc\motd
"  " to get rid of the 'Welcome to Git' message
"  set shell=cmd.exe
"  set shellcmdflag=/c\ \"C:\\Progra~1\\Git\\bin\\bash.exe\ --login\ -c\"
"
"  " Leader c for commandline, Leader e to exit
"  nmap <Leader>c :term<CR>acmd.exe /c "C:\\Progra~1\Git\bin\bash.exe --login -i"<CR>
"  :tnoremap <Leader>e exit<CR>exit<CR>
"endif

"syntax
syntax on
"xaml
au BufNewFile,BufRead *.xaml    setf xml

set guicursor=
set noshowmatch
set relativenumber
set nohlsearch
set noerrorbells

"Indenting - use tabs
set smartindent
set noexpandtab
set tabstop=4
set shiftwidth=4

set nu
set nowrap
set smartcase
set noswapfile
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8

"View hidden characters
:set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»

"coc.nvim
" TextEdit might fail if hidden is not set.
set hidden
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2
" Having longer updatetime (default is 4000 ms = 4 s)
" leads to noticeable delays and poor user experience.
"set updatetime=50

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

"folding
set foldmethod=syntax
"set foldnestmax=10
"set foldlevel=3
set foldcolumn=2
set foldenable

" C# Folding : ~/nvim/after/syntax/cs.vim https://github.com/OmniSharp/omnisharp-vim/issues/218

"Default page width visual
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey
autocmd BufNewFile,BufRead *.cs set colorcolumn=160
autocmd BufNewFile,BufRead *.xaml set colorcolumn=160

"Plugins
call plug#begin('~/.vim/plugged')

" C#
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'tpope/vim-fugitive'
Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'
Plug 'sheerun/vim-polyglot'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

"  I AM SO SORRY FOR DOING COLOR SCHEMES IN MY VIMRC, BUT I HAVE
"  TOOOOOOOOOOOOO
Plug 'gruvbox-community/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'phanviet/vim-monokai-pro'
Plug 'vim-airline/vim-airline'
Plug 'flazz/vim-colorschemes'
"Plug 'ThePrimeagen/vim-be-good', {'do': './install.sh'}

call plug#end()

"coc.nvim omnisharp
let g:coc_global_extensions=[ 'coc-omnisharp']

let g:gruvbox_contrast_dark = 'hard'
if exists('+termguicolors')
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif
let g:gruvbox_invert_selection='0'

" --- vim go (polyglot) settings.
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_auto_sameids = 1

colorscheme gruvbox
set background=dark

if executable('rg')
    let g:rg_derive_root='true'
endif

"Mappings
let loaded_matchparen = 1
let mapleader = " "

let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25

let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let $FZF_DEFAULT_OPTS='--reverse'
let g:fzf_branch_actions = {
      \ 'rebase': {
      \   'prompt': 'Rebase> ',
      \   'execute': 'echo system("{git} rebase {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-r',
      \   'required': ['branch'],
      \   'confirm': v:true,
      \ },
      \ 'track': {
      \   'prompt': 'Track> ',
      \   'execute': 'echo system("{git} checkout --track {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-t',
      \   'required': ['branch'],
      \   'confirm': v:true,
      \ },
      \ 'upstream': {
      \   'prompt': 'Upstream> ',
      \   'execute': 'echo system("{git} push --set-upstream origin {branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-u',
      \   'required': ['branch'],
      \   'confirm': v:true,
      \ },
      \}

nnoremap <leader>gc :GBranches<CR>
nnoremap <leader>glc :GBranches --locals<CR>
nnoremap <leader>grc :GBranches --remotes<CR>
nnoremap <leader>gfa :Git fetch --all<CR>
nnoremap <leader>gfm :Git fetch -f origin master:master<CR>

nnoremap <leader>grom :Git rebase origin/master<CR>

nnoremap <leader>pw :Rg <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>phw :h <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>
nnoremap <Leader>ps :Rg<SPACE>
nnoremap <C-p> :GFiles<CR>
nnoremap <C-l> :Buffers<CR>
nnoremap <Leader>pf :Files<CR>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
nnoremap <Leader>rp :resize 100<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap X "_d

" greatest remap ever
vnoremap <leader>p "_dP

"Begin personal mapping
map S ddO
map cc S

" CTRL-X and SHIFT-Del are Cut
vnoremap <C-X> "+x
vnoremap <S-Del> "+x
" CTRL-C and CTRL-Insert are Copy
vnoremap <C-C> "+y
vnoremap <C-Insert> "+y
" CTRL-V and SHIFT-Insert are Paste
map <C-V>		"+gP
map <S-Insert>		"+gP
imap <C-V>		<Esc>"+gpa
cmap <C-V>		<C-R>+
cmap <S-Insert>		<C-R>+
imap <S-Insert>		<C-V>
vmap <S-Insert>		<C-V>
" Use CTRL-Q to do what CTRL-V used to do
noremap <C-Q>		<C-V>

map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>

"Auto indent
nnoremap <leader>ai mz :%g!/region/normal ==`z<CR>

"Close buffer
nnoremap <Leader>q :bd<CR>
nnoremap <Leader>qa :bufdo bd<CR>

"End Personal remapping

" Vim with me
nnoremap <leader>vwm :colorscheme gruvbox<bar>:set background=dark<CR>
nmap <leader>vtm :highlight Pmenu ctermbg=gray guibg=gray

inoremap <C-c> <esc>

"coc.nvim mapping
inoremap <silent><expr> <C-space> coc#refresh()
" GoTo code navigation.
nmap <leader>cs :CocSearch <C-R>=expand("<cword>")<CR><CR>
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gy <Plug>(coc-type-definition)
nmap <leader>gi <Plug>(coc-implementation)
nmap <leader>gr <Plug>(coc-references)
nmap <leader>rr <Plug>(coc-rename)
nmap <leader>g[ <Plug>(coc-diagnostic-prev)
nmap <leader>g] <Plug>(coc-diagnostic-next)
nmap <silent> <leader>gp <Plug>(coc-diagnostic-prev-error)
nmap <silent> <leader>gn <Plug>(coc-diagnostic-next-error)
nnoremap <leader>cr :CocRestart

"coc.nvim additional setting begin

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

command! -nargs=0 Prettier :CocCommand prettier.formatFile

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

"coc.nvim additional setting end

" Sweet Sweet FuGITive
nmap <leader>gh :diffget //3<CR>
nmap <leader>gu :diffget //2<CR>
nmap <leader>gs :G<CR>

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank("IncSearch", 50)
augroup END

"Handle white space
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

autocmd BufWritePre * :call TrimWhitespace()
