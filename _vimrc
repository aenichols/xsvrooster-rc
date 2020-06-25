" Vim with all enhancements
source $VIMRUNTIME/vimrc_example.vim

" Remap a few keys for Windows behavior
source $VIMRUNTIME/mswin.vim

" Use the internal diff if available.
" Otherwise use the special 'diffexpr' for Windows.
if &diffopt !~# 'internal'
  set diffexpr=MyDiff()
endif
function MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg1 = substitute(arg1, '!', '\!', 'g')
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg2 = substitute(arg2, '!', '\!', 'g')
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let arg3 = substitute(arg3, '!', '\!', 'g')
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      if empty(&shellxquote)
        let l:shxq_sav = ''
        set shellxquote&
      endif
      let cmd = '"' . $VIMRUNTIME . '\diff"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  let cmd = substitute(cmd, '!', '\!', 'g')
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3
  if exists('l:shxq_sav')
    let &shellxquote=l:shxq_sav
  endif
endfunction

"Begin Personal remapping                                                                                                                                                                                                                       
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
"End Personal remapping   

"Used for YCM
" Enable debugging
let g:ycm_keep_logfiles = 1
let g:ycm_log_level = 'debug'
set encoding=utf-8

" Use the vim-plug plugin manager: https://github.com/junegunn/vim-plug
" Remember to run :PlugInstall when loading this vimrc for the first time, so
" vim-plug downloads the plugins listed.
silent! if plug#begin('~/.vim/plugged')
" C#
Plug 'OmniSharp/omnisharp-vim'
Plug 'w0rp/ale'

" File Explorer
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

"YCM
Plug 'Valloric/YouCompleteMe', { 'do': './python3 install.py --clang-completer --system-libclang' }

call plug#end()
endif

" Note: this is required for the plugin to work
filetype indent plugin on

" Use the stdio OmniSharp-roslyn server
let g:OmniSharp_server_stdio = 1

" Set the type lookup function to use the preview window instead of echoing it
"let g:OmniSharp_typeLookupInPreview = 1

" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 5

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview', 'popup'
" and 'popuphidden' if you don't want to see any documentation whatsoever.
" Note that neovim does not support `popuphidden` or `popup` yet: 
" https://github.com/neovim/neovim/issues/10996
set completeopt=longest,menuone,preview,popuphidden

" Highlight the completion documentation popup background/foreground the same as
" the completion menu itself, for better readability with highlighted
" documentation.
set completepopup=highlight:Pmenu,border:off

" Fetch full documentation during omnicomplete requests.
" By default, only Type/Method signatures are fetched. Full documentation can
" still be fetched when you need it with the :OmniSharpDocumentation command.
let g:omnicomplete_fetch_full_documentation = 1

" Set desired preview window height for viewing documentation.
" You might also want to look at the echodoc plugin.
set previewheight=5

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters = { 'cs': ['OmniSharp'] }

" Update semantic highlighting on BufEnter, InsertLeave and TextChanged
let g:OmniSharp_highlight_types = 2

augroup omnisharp_commands
    autocmd!

    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    autocmd CursorHold *.cs OmniSharpTypeLookup

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
augroup END

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <Leader>nm :OmniSharpRename<CR>
nnoremap <F2> :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <Leader>ss :OmniSharpStartServer<CR>
nnoremap <Leader>sp :OmniSharpStopServer<CR>