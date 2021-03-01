cd /SourceTree

"syntax
syntax on
"xaml
au BufNewFile,BufRead *.xaml    setf xml
"Razor
au BufNewFile,BufRead *.cshtml set syntax=html

set exrc
set guicursor=
set noshowmatch
set relativenumber
set hlsearch
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
set nobackup
set undodir=~/.vim/undodir
set undofile
set incsearch
set termguicolors
set scrolloff=8

set mouse=a

"View hidden characters
:set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»

"coc.nvim
" TextEdit might fail if hidden is not set.
set hidden
set nobackup
set nowritebackup
" Give more space for displaying messages.
set cmdheight=2

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

"folding
set foldmethod=syntax
set foldcolumn=2
set foldenable

" C# Folding : ~/nvim/after/syntax/cs.vim https://github.com/OmniSharp/omnisharp-vim/issues/218

"Default page width visual
set colorcolumn=80
autocmd BufNewFile,BufRead *.cs set colorcolumn=160
autocmd BufNewFile,BufRead *.xaml set colorcolumn=160

"Plugins
call plug#begin('~/.vim/plugged')

"Omni
Plug 'OmniSharp/omnisharp-vim'
Plug 'dense-analysis/ale'

"We don't deserve Tim Pope
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-fugitive'

Plug 'vim-utils/vim-man'
Plug 'mbbill/undotree'

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'

Plug 'ncm2/float-preview.nvim'

"  I AM SO SORRY FOR DOING COLOR SCHEMES IN MY VIMRC, BUT I HAVE
"  TOOOOOOOOOOOOO
Plug 'gruvbox-community/gruvbox'
Plug 'sainnhe/gruvbox-material'
Plug 'phanviet/vim-monokai-pro'
Plug 'vim-airline/vim-airline'
Plug 'flazz/vim-colorschemes'

Plug 'brooth/far.vim'

"CocSearch alternative
Plug 'dyng/ctrlsf.vim'

call plug#end()

let g:float_preview#docked = 0
let g:float_preview#max_width = 300 "Default 50
set completeopt=longest,menuone,noinsert,noselect
set previewheight=5

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters = { 'cs': ['OmniSharp'] }
let g:ale_sign_column_always = 1
nmap <silent> <C-k> <Plug>(ale_previous)
nmap <silent> <C-j> <Plug>(ale_next)

"Omni use fzf
let g:OmniSharp_selector_ui = 'fzf'
let g:OmniSharp_selector_findusages = 'fzf'

augroup omnisharp_commands
  autocmd!

  " Show type information automatically when the cursor stops moving.
  " Note that the type is echoed to the Vim command line, and will overwrite
  " any other messages in this space including e.g. ALE linting messages.
  autocmd CursorHold *.cs OmniSharpTypeLookup

  " The following commands are contextual, based on the cursor position.
  autocmd FileType cs nmap <silent> <buffer> <Leader>gd <Plug>(omnisharp_go_to_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ofu <Plug>(omnisharp_find_usages)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ofi <Plug>(omnisharp_find_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>opd <Plug>(omnisharp_preview_definition)
  autocmd FileType cs nmap <silent> <buffer> <Leader>opi <Plug>(omnisharp_preview_implementations)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ot <Plug>(omnisharp_type_lookup)
  autocmd FileType cs nmap <silent> <buffer> K <Plug>(omnisharp_documentation)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ofs <Plug>(omnisharp_find_symbol)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ofx <Plug>(omnisharp_fix_usings)
  autocmd FileType cs nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
  autocmd FileType cs imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

  " Navigate up and down by method/property/field
  autocmd FileType cs nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
  autocmd FileType cs nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
  " Find all code errors/warnings for the current solution and populate the quickfix window
  autocmd FileType cs nmap <silent> <buffer> <Leader>ogcc <Plug>(omnisharp_global_code_check)
  " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
  autocmd FileType cs nmap <silent> <buffer> <Leader>oca <Plug>(omnisharp_code_actions)
  autocmd FileType cs xmap <silent> <buffer> <Leader>oca <Plug>(omnisharp_code_actions)
  " Repeat the last code action performed (does not use a selector)
  autocmd FileType cs nmap <silent> <buffer> <Leader>o. <Plug>(omnisharp_code_action_repeat)
  autocmd FileType cs xmap <silent> <buffer> <Leader>o. <Plug>(omnisharp_code_action_repeat)

  autocmd FileType cs nmap <silent> <buffer> <Leader>o= <Plug>(omnisharp_code_format)

  autocmd FileType cs nmap <silent> <buffer> <Leader>orr <Plug>(omnisharp_rename)

  autocmd FileType cs nmap <silent> <buffer> <Leader>ore <Plug>(omnisharp_restart_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_start_server)
  autocmd FileType cs nmap <silent> <buffer> <Leader>osp <Plug>(omnisharp_stop_server)
augroup END

let g:theprimeagen_colorscheme = "gruvbox"
fun! ColorMyPencils()
    colorscheme ayu
    set background=dark

    let g:gruvbox_contrast_dark = 'hard'
    if exists('+termguicolors')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    let g:gruvbox_invert_selection='0'

    highlight Visual term=reverse cterm=reverse guibg=#504945

    highlight ColorColumn ctermbg=0 guibg=grey
    highlight Normal guibg=none " for gruvbox dark #282828, use 'none' for trans term
    highlight Folded guibg=none

    highlight LineNr guifg=#5eacd3
    highlight netrwDir guifg=#5eacd3
    highlight qfFileName guifg=#aed75f
endfun
call ColorMyPencils()

if executable('rg')
    let g:rg_derive_root='true'
endif

"Mappings
let loaded_matchparen = 1
let mapleader = " "

let g:netrw_browse_split = 2
let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:netrw_localrmdir='rm -r'

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
      \ 'fetch': {
      \   'prompt': 'Fetch> ',
      \   'execute': 'echo system("{git} fetch -f origin {branch}:{branch}")',
      \   'multiple': v:false,
      \   'keymap': 'ctrl-f',
      \   'required': ['branch'],
      \   'confirm': v:true,
      \ }
      \}

nnoremap <leader>gc :GBranches<CR>
nnoremap <leader>glc :GBranches --locals<CR>
nnoremap <leader>grc :GBranches --remotes<CR>
nnoremap <leader>gfa :Git fetch --all<CR>
nnoremap <leader>gfm :Git fetch -f origin master:master<CR>

nnoremap <leader>grom :Git rebase origin/master<CR>

nnoremap <leader>pw :Rg <C-R>=expand("<cword>")<CR><CR>
nnoremap <leader>bs /<C-R>=escape(expand("<cWORD>"), "/")<CR><CR>
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pv :wincmd v<bar> :Ex <bar> :vertical resize 30<CR>

nnoremap <Leader>ps :Rg<SPACE>
nnoremap <C-p> :GFiles<CR>
nnoremap <Leader>pf :Files<CR>
nnoremap <Leader>+ :vertical resize +5<CR>
nnoremap <Leader>- :vertical resize -5<CR>
nnoremap <Leader>rp :resize 100<CR>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
vnoremap X "_d

" Maps Alt-[Arrows] to resizing a window split
map <silent> <C-LEFT> <C-w><
map <silent> <C-DOWN> <C-W>-
map <silent> <C-UP> <C-W>+
map <silent> <C-RIGHT> <C-w>>

" greatest remap ever
vnoremap <leader>p "_dP

"Begin personal mapping
nnoremap <C-w>f <C-w>_<C-w>|
nnoremap <C-l> :Buffers<CR>
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

"CtrlSF
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>

let g:ctrlsf_auto_focus = {
    \ "at": "start"
    \ }

" Vim with me
nnoremap <leader>vwm :call ColorMyPencils()<CR>
inoremap <C-c> <esc>

" Sweet Sweet FuGITive
nmap <leader>gl :diffget //3<CR>
nmap <leader>gh :diffget //2<CR>
nmap <leader>gs :G<CR>

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({timeout = 40})
augroup END

"Handle white space
fun! TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfun

autocmd BufWritePre * :call TrimWhitespace()

" Colorize line numbers in insert and visual modes
" ------------------------------------------------
function! SetCursorLineNrColorInsert(mode)
    " Insert mode: blue
    if a:mode == "i"
        highlight CursorLineNr ctermfg=4 guifg=#26d2c4

    " Replace mode: red
    elseif a:mode == "r"
        highlight CursorLineNr ctermfg=1 guifg=#dc322f

    endif
endfunction


function! SetCursorLineNrColorVisual()
    set updatetime=0

    " Visual mode: yellow
    highlight CursorLineNr cterm=none ctermfg=9 guifg=#d29026

	" Set list
	set list

	return ''
endfunction


function! ResetCursorLineNrColor()
    set updatetime=4000
    highlight CursorLineNr cterm=none ctermfg=0 guifg=#d2c926
	set nolist
endfunction


vnoremap <silent> <expr> <SID>SetCursorLineNrColorVisual SetCursorLineNrColorVisual()
nnoremap <silent> <script> v v<SID>SetCursorLineNrColorVisual
nnoremap <silent> <script> V V<SID>SetCursorLineNrColorVisual
nnoremap <silent> <script> <C-v> <C-v><SID>SetCursorLineNrColorVisual


augroup CursorLineNrColorSwap
    autocmd!
    autocmd InsertEnter * call SetCursorLineNrColorInsert(v:insertmode)
    autocmd InsertLeave * call ResetCursorLineNrColor()
    autocmd CursorHold * call ResetCursorLineNrColor()
augroup END
