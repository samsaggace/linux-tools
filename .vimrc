" enable syntax highlighting
syntax on

"set autoindent
set cindent
"set indentexpr

" allow backspace
set backspace=indent,start,eol

" display line and column number
set ruler

" don't limit width of screen
set textwidth=0  

" Tag list
let Tlist_Ctags_Cmd = 'ctags'


" highlight search on
set hlsearch
" CTRL-N stop hlsearch
nmap <silent> <C-N> :silent noh<CR>
" "search as we type" on
set incsearch

"command GP :execute 'vimgrep /'.expand('<cword>').'/j **') | copen
"command -nargs=* GREP :execute 'vimgrep /'.expand('<args>')'/j **' | copen 15
command -nargs=* GREP :execute 'vimgrep' .expand('<args>') | copen 15

" cindent option
set cinoptions=t0,(0,W4,l1,g0,hs

" I starts at the first non-blank character
set cpoptions+=H

" replace tab with 4 spaces
if strpart(system("hostname"), 0, 4) == "rmmp"
    set shiftwidth=3 tabstop=3 expandtab
else
    set shiftwidth=4 tabstop=4 expandtab
endif

set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.svn

set listchars+=tab:\|-

set dictionary=/usr/share/dict/french

"Keep version with savevers
"set backup
"set patchmode=.bak
"set backupskip+=*.bak
"set wildignore+=*.bak
"let savevers_types = "*"
"nmap <silent> <F8> :VersDiff 1<cr>

" Cscope 
" --------------------------------------------------------------------------
if has("cscope")
	" change this to 1 to search ctags DBs first
	set csto=0
	set cst
	set nocsverb
	" add any database in current directory
	if filereadable(".vimtags/cscope.out")
	    cs add .vimtags/cscope.out
	" else add database pointed to by environment
	elseif $CSCOPE_DB != ""
	    cs add $CSCOPE_DB
	endif
	set csverb

	" Using 'CTRL-AltGr \' then a search type makes the vim window
	" "shell-out", with search results displayed on the bottom

	nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

	" Using 'CTRL-AltGr ^' then a search type makes the vim window
	" split horizontally, with search result displayed in
	" the new window.

	nmap <C-^>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
	nmap <C-^>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
	nmap <C-^>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
	nmap <C-^>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
	nmap <C-^>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
	nmap <C-^>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
	nmap <C-^>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
	nmap <C-^>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>

endif

"--------------------------------------------------------------------------
" Omnicompletion, needs tags
set omnifunc=ccomplete#Complete
set shiftwidth=3 tabstop=3 expandtab
if $VIMTAGSPATH != ""
   set tags+=$VIMTAGSPATH/tags
elseif filereadable(".vimtags/tags") 
   set tags+=.vimtags/tags
endif
source $VIM/vim71/autoload/ccomplete.vim


"---------------------------------------------------------------------------
" tab completion from tags or cscope
function! InsertTabWrapper(direction)
    let col = col('.') - 1
    if !col || getline('.')[col - 1] =~ '\s'
        return "\<Tab>"
    elseif "backward" == a:direction
        return "\<C-P>"
    else
        return "\<C-N>"
    endif
endfunction

inoremap <Tab> <C-R>=InsertTabWrapper("forward")<cr>
inoremap <s-tab> <C-R>=InsertTabWrapper("backward")<cr>
inoremap <leader><Tab> <Tab>

"---------------------------------------------------------------------------
" man page in new tab function
" ex: :Man 2 read
function! ManPage(arg)
    let file = tempname()
    let width = winwidth(0)

    let manpagewidth = width
    if (col("$") != 1 || line("$") != 1) && width > 160
        let manpagewidth = manpagewidth / 2 - 1
    endif

    if g:debian == 1
        call system("COLUMNS=".manpagewidth." /usr/bin/man -Pcat ".a:arg." 2>/dev/null >".file)
    else
        call system("COLUMNS=".manpagewidth." /usr/bin/man -Pcat ".a:arg." 2>/dev/null | col -b >".file)
    endif
    if getfsize(file) > 0
        if col("$") != 1 || line("$") != 1
            if width > 160
                exe "rightbelow vnew ".file
            else
                exe "new ".file
            endif
        else
            exe "e ".file
        endif
        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal noswapfile
        setlocal syntax=man
        setlocal noma nomod ro
    else
        echohl ErrorMsg
        echo "Man page not found"
        echohl None
        if bufnr("$") == 1 && col("$") == 1 && line("$") == 1
            q
        endif
    endif
    call delete(file)
endfunction
command! -nargs=+ Man :call ManPage("<args>")

function! ManCurrentWord()
    let word = expand("<cword>")

    let file = tempname()
    let width = winwidth(0)

    let manpagewidth = width
    if width > 160
        let manpagewidth = manpagewidth / 2 - 1
    endif

    call system("COLUMNS=".manpagewidth." /usr/bin/man -Pcat 2 ".word." 2>/dev/null >".file)
    if getfsize(file) == 0
        call system("COLUMNS=".manpagewidth." /usr/bin/man -Pcat 3 ".word." 2>/dev/null >".file)
        if getfsize(file) == 0
            call system("COLUMNS=".manpagewidth." /usr/bin/man -Pcat ".word." 2>/dev/null >".file)
        endif
    endif
    if getfsize(file) > 0
        if width > 160
            exe "rightbelow vnew ".file
        else
            exe "new ".file
        endif
        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal noswapfile
        setlocal syntax=man
        setlocal noma nomod ro
        wincmd p
    endif

    call delete(file)
endfunction
map <silent> K :call ManCurrentWord()<CR>

"---------------------------------------------------------------------------
" make with errors
"set makeprg=make\ -j2
"nnoremap <silent> <F9> :make<CR><CR>:cw<CR>
"nnoremap <silent> <C-Up> :cp<CR>
"nnoremap <silent> <C-Down> :cn<CR>
"inoremap <silent> <C-Up> <ESC>:cp<CR>i
"inoremap <silent> <C-Down> <ESC>:cn<CR>i
"
"---------------------------------------------------------------------------
map ,v :split $MYVIMRC<CR>
map ,/ :s/^\([[:space:]]*\)/\1\/\//<CR><C-N>
map ,# :s/^/#/<CR><C-N>
map ," :s/^/"/<CR><C-N>

map <C-z> :shell<CR><CR>

map ,z :set fdm=indent<CR>zM<CR>

map <F3>   :TlistUpdate<CR>
map <F4>   :TlistToggle<CR>
map <F5>   :.s@^\(.*\)$@\/\* \1 \*\/@g<CR><C-N>
map <F6>   :.s@^\/\* \(.*\) \*\/$@\1@g<CR><C-N>

map <C-Del>   :bdelete<CR>
map <C-Left>  :bp!<CR>
map <C-Right> :bn!<CR>
map <C-Down>  ]c
map <C-Up>    [c

"---------------------------------------------------------------------------
"function! Sparse(filename)
"    let file = tempname()
"
"    call system("sparse -D__i386__ ".a:filename." 2>".file)
"
"    exe "cgetfile ".file
"    cwindow
"
"    call delete(file)
"endfunction


function! GetSagemPath(pathname)
   if a:pathname == $HOME || a:pathname == '/'
      return
   endif

   if isdirectory(a:pathname."/h")
      execute "set path+=".a:pathname."/h"
   endif
   if isdirectory(a:pathname."/h_protected")
      execute "set path+=".a:pathname."/h_protected"
   endif
   if isdirectory(a:pathname."/include")
      execute "set path+=".a:pathname."/include"
   endif

   call GetSagemPath(fnamemodify(a:pathname, ":h"))
endfunction

au BufNewFile,BufRead *.c,*.h 
      \ set path=. |
      \ call GetSagemPath(expand("<amatch>:h"))

"---------------------------------------------------------------------------
" force use of tabs in Makefiles
au BufNewFile,BufRead Makefile*,GNUmakefile*,*.mk
    \ set shiftwidth=8 tabstop=8 noexpandtab

au BufNewFile,BufRead *.pl*
    \ set shiftwidth=2 tabstop=8 softtabstop=2 noexpandtab

au BufNewFile,BufRead *.s
    \ set shiftwidth=8 tabstop=8 noexpandtab



map ,l :so ~/.vimrc<CR>

"---------------------------------------------------------------------------
" Diff style
if &diff
    au BufWritePost * diffupdate
endif
highlight DiffAdd ctermfg=black ctermbg=green cterm=none
highlight DiffChange ctermfg=none ctermbg=none cterm=standout
highlight DiffDelete ctermfg=black ctermbg=red cterm=none
highlight DiffText ctermfg=black ctermbg=yellow cterm=none
highlight Folded ctermbg=black ctermfg=grey


" GPG
command! -nargs=0 Decrypt :%!gpg --decrypt 2> /dev/null


"---------------------------------------------------------------------------
"Highlight when > 80 columns

let g:isshow = 0

function! Show80col()
    if g:isshow == 0
      let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
      let g:isshow = 1
      echo 'Showing lines with more than 80 columns'
    else
      call matchdelete(w:m2)
      let g:isshow = 0
      echo 'Hiding lines with more than 80 columns'
    endif
endfunction


map <silent> <F2> :call Show80col()<CR>

"-------------------------------------------------------------------------
"Color and font :
so $VIMRUNTIME/colors/desert.vim
set guifont=Monospace\ 9

"-------------------------------------------------------------------------
"Highlight Patch like TODO :
au BufNewFile,BufRead *.c,*.h,*.cpp,*.patch 
 \ let g:m4=matchadd('Todo', '\c/\*.*PATCH.*', -1) |
 \ let g:m5=matchadd('Todo', '\c//.*PATCH.*', -1)

au BufNewFile,BufRead Makefile*,GNUmakefile*,*.mk,*.patch 
 \ let g:m6=matchadd('Todo', '\c#.*PATCH.*', -1)

"let g:netrw_altv = 1
"let g:netrw_alto = 1
set splitright

" Load Dowygen syntax automaticaly
let g:load_doxygen_syntax=1



"---------------------------------------------------------------------
"tal : align "\" in multiple lines defines

vmap ,t !tal<CR>
