" Vim filetype plugin file (GUI menu, folding and completion)
" Language:	Debian Changelog
" Maintainer:	Michael Piefel <piefel@informatik.hu-berlin.de>
"		Stefano Zacchiroli <zack@debian.org>
" Last Change:	$LastChangedDate: 2007-04-10 08:54:47 -0400 (Tue, 10 Apr 2007) $
" License:	GNU GPL, version 2.0 or later
" URL:		http://svn.debian.org/wsvn/pkg-vim/trunk/runtime/ftplugin/debchangelog.vim?op=file&rev=0&sc=0

if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin=1

" {{{1 Local settings (do on every load)
if !exists("g:debchangelog_fold_disable")
  setlocal foldmethod=expr
endif
setlocal foldexpr=DebGetChangelogFold(v:lnum)
setlocal foldtext=DebChangelogFoldText()

" Debian changelogs are not supposed to have any other text width,
" so the user cannot override this setting
setlocal tw=78
setlocal comments=f:*

" Clean unloading
let b:undo_ftplugin = "setlocal tw< comments< foldmethod< foldexpr< foldtext<"
" }}}1

if exists("g:did_changelog_ftplugin")
  finish
endif

" Don't load another plugin (this is global)
let g:did_changelog_ftplugin = 1

" {{{1 GUI menu

" Helper functions returning various data.
" Returns full name, either from $DEBFULLNAME or debianfullname.
" TODO Is there a way to determine name from anywhere else?
function <SID>FullName()
    if exists("$DEBFULLNAME")
	return $DEBFULLNAME
    elseif exists("g:debianfullname")
	return g:debianfullname
    else
	return "Your Name"
    endif
endfunction

" Returns email address, from $DEBEMAIL, $EMAIL or debianemail.
function <SID>Email()
    if exists("$DEBEMAIL")
	return $DEBEMAIL
    elseif exists("$EMAIL")
	return $EMAIL
    elseif exists("g:debianemail")
	return g:debianemail
    else
	return "your@email.address"
    endif
endfunction

" Returns date in RFC822 format.
function <SID>Date()
    let savelang = v:lc_time
    execute "language time C"
    let dateandtime = strftime("%a, %d %b %Y %X %z")
    execute "language time " . savelang
    return dateandtime
endfunction

function <SID>WarnIfNotUnfinalised()
    if match(getline("."), " -- [[:alpha:]][[:alnum:].]")!=-1
	echohl WarningMsg
	echo "The entry has not been unfinalised before editing."
	echohl None
	return 1
    endif
    return 0
endfunction

function <SID>Finalised()
    let savelinenum = line(".")
    normal 1G
    call search("^ -- ")
    if match(getline("."), " -- [[:alpha:]][[:alnum:].]")!=-1
	let returnvalue = 1
    else
	let returnvalue = 0
    endif
    execute savelinenum
    return returnvalue
endfunction

" These functions implement the menus
function NewVersion()
    " The new entry is unfinalised and shall be changed
    amenu disable Changelog.New\ Version
    amenu enable Changelog.Add\ Entry
    amenu enable Changelog.Close\ Bug
    amenu enable Changelog.Set\ Distribution
    amenu enable Changelog.Set\ Urgency
    amenu disable Changelog.Unfinalise
    amenu enable Changelog.Finalise
    call append(0, substitute(getline(1), '-\([[:digit:]]\+\))', '-$$\1)', ''))
    call append(1, "")
    call append(2, "")
    call append(3, " -- ")
    call append(4, "")
    call Distribution("unstable")
    call Urgency("low")
    normal 1G
    call search(")")
    normal h
    normal 
    call setline(1, substitute(getline(1), '-\$\$', '-', ''))
    normal zo
    call AddEntry()
endfunction

function AddEntry()
    normal 1G
    call search("^ -- ")
    normal kk
    call append(".", "  * ")
    normal jjj
    let warn=<SID>WarnIfNotUnfinalised()
    normal kk
    if warn
	echohl MoreMsg
	call input("Hit ENTER")
	echohl None
    endif
    startinsert!
endfunction

function CloseBug()
    normal 1G
    call search("^ -- ")
    let warn=<SID>WarnIfNotUnfinalised()
    normal kk
    call append(".", "  *  (closes: #" . input("Bug number to close: ") . ")")
    normal j^ll
    startinsert
endfunction

function Distribution(dist)
    call setline(1, substitute(getline(1), ") [[:lower:] ]*;", ") " . a:dist . ";", ""))
endfunction

function Urgency(urg)
    call setline(1, substitute(getline(1), "urgency=.*$", "urgency=" . a:urg, ""))
endfunction

function <SID>UnfinaliseMenu()
    " This means the entry shall be changed
    amenu disable Changelog.New\ Version
    amenu enable Changelog.Add\ Entry
    amenu enable Changelog.Close\ Bug
    amenu enable Changelog.Set\ Distribution
    amenu enable Changelog.Set\ Urgency
    amenu disable Changelog.Unfinalise
    amenu enable Changelog.Finalise
endfunction

function Unfinalise()
    call <SID>UnfinaliseMenu()
    normal 1G
    call search("^ -- ")
    call setline(".", " -- ")
endfunction

function <SID>FinaliseMenu()
    " This means the entry should not be changed anymore
    amenu enable Changelog.New\ Version
    amenu disable Changelog.Add\ Entry
    amenu disable Changelog.Close\ Bug
    amenu disable Changelog.Set\ Distribution
    amenu disable Changelog.Set\ Urgency
    amenu enable Changelog.Unfinalise
    amenu disable Changelog.Finalise
endfunction

function Finalise()
    call <SID>FinaliseMenu()
    normal 1G
    call search("^ -- ")
    call setline(".", " -- " . <SID>FullName() . " <" . <SID>Email() . ">  " . <SID>Date())
endfunction


function <SID>MakeMenu()
    amenu &Changelog.&New\ Version			:call NewVersion()<CR>
    amenu Changelog.&Add\ Entry				:call AddEntry()<CR>
    amenu Changelog.&Close\ Bug				:call CloseBug()<CR>
    menu Changelog.-sep-				<nul>

    amenu Changelog.Set\ &Distribution.&unstable	:call Distribution("unstable")<CR>
    amenu Changelog.Set\ Distribution.&frozen		:call Distribution("frozen")<CR>
    amenu Changelog.Set\ Distribution.&stable		:call Distribution("stable")<CR>
    menu Changelog.Set\ Distribution.-sep-		<nul>
    amenu Changelog.Set\ Distribution.frozen\ unstable	:call Distribution("frozen unstable")<CR>
    amenu Changelog.Set\ Distribution.stable\ unstable	:call Distribution("stable unstable")<CR>
    amenu Changelog.Set\ Distribution.stable\ frozen	:call Distribution("stable frozen")<CR>
    amenu Changelog.Set\ Distribution.stable\ frozen\ unstable	:call Distribution("stable frozen unstable")<CR>

    amenu Changelog.Set\ &Urgency.&low			:call Urgency("low")<CR>
    amenu Changelog.Set\ Urgency.&medium		:call Urgency("medium")<CR>
    amenu Changelog.Set\ Urgency.&high			:call Urgency("high")<CR>

    menu Changelog.-sep-				<nul>
    amenu Changelog.U&nfinalise				:call Unfinalise()<CR>
    amenu Changelog.&Finalise				:call Finalise()<CR>

    if <SID>Finalised()
	call <SID>FinaliseMenu()
    else
	call <SID>UnfinaliseMenu()
    endif
endfunction

augroup changelogMenu
au BufEnter * if &filetype == "debchangelog" | call <SID>MakeMenu() | endif
au BufLeave * if &filetype == "debchangelog" | aunmenu Changelog | endif
augroup END

" }}}
" {{{1 folding

" look for an author name in the [zonestart zoneend] lines searching backward
function! s:getAuthor(zonestart, zoneend)
  let linepos = a:zoneend
  while linepos >= a:zonestart
    let line = getline(linepos)
    if line =~ '^ --'
      return substitute(line, '^ --\s*\([^<]\+\)\s*.*', '\1', '')
    endif
    let linepos -= 1
  endwhile
  return '[unknown]'
endfunction

" Look for a package source name searching backward from the givenline and
" returns it. Return the empty string if the package name can't be found
function! DebGetPkgSrcName(lineno)
  let lineidx = a:lineno
  let pkgname = ''
  while lineidx > 0
    let curline = getline(lineidx)
    if curline =~ '^\S'
      let pkgname = matchlist(curline, '^\(\S\+\).*$')[1]
      break
    endif
    let lineidx = lineidx - 1
  endwhile
  return pkgname
endfunction

function! DebChangelogFoldText()
  if v:folddashes == '-'  " changelog entry fold
    return foldtext() . ' -- ' . s:getAuthor(v:foldstart, v:foldend) . ' '
  endif
  return foldtext()
endfunction

function! DebGetChangelogFold(lnum)
  let line = getline(a:lnum)
  if line =~ '^\w\+'
    return '>1' " beginning of a changelog entry
  endif
  if line =~ '^\s\+\[.*\]'
    return '>2' " beginning of an author-specific chunk
  endif
  if line =~ '^ --'
    return '1'
  endif
  return '='
endfunction

silent! foldopen!   " unfold the entry the cursor is on (usually the first one)

" }}}

" {{{1 omnicompletion for Closes: #

if !exists('g:debchangelog_listbugs_severities')
  let g:debchangelog_listbugs_severities = 'critical,grave,serious,important,normal,minor,wishlist'
endif

fun! DebCompleteBugs(findstart, base)
  if a:findstart
    " it we are just after an '#', the completion should start at the '#',
    " otherwise no completion is possible
    let line = getline('.')
    let colidx = col('.')
    if colidx > 1 && line[colidx - 2] =~ '#'
      let colidx = colidx - 2
    else
      let colidx = -1
    endif
    " try to detect whether this is closes: or lp:
    let g:debchangelog_complete_mode = 'debbugs'
    let try_colidx = colidx
    while try_colidx > 0 && line[try_colidx - 1] =~ '\s\|\d\|#\|,'
      let try_colidx = try_colidx - 1
      if line[try_colidx - 1] == ':'
        if try_colidx > 2 && strpart(line, try_colidx - 3, 3) =~ '\clp:'
          let g:debchangelog_complete_mode = 'lp'
        endif
        break
      endif
    endwhile
    return colidx
  else
    if g:debchangelog_complete_mode == 'lp'
      if ! has('python')
        echoerr 'vim must be built with Python support to use LP bug completion'
        return
      endif
      let pkgsrc = DebGetPkgSrcName(line('.'))
      python << EOF
import vim
from launchpadbugs import connector
buglist = connector.ConnectBugList()
bl = list(buglist('https://bugs.launchpad.net/ubuntu/+source/%s' % vim.eval('pkgsrc')))
bl.sort(None, int)
liststr = '['
for bug in bl:
    liststr += "'#%d - %s'," % (int(bug), bug.summary.replace('\'', '\'\''))
liststr += ']'
vim.command('silent let bug_lines = %s' % liststr)
EOF
    else
      if ! filereadable('/usr/sbin/apt-listbugs')
        echoerr 'apt-listbugs not found, you should install it to use Closes bug completion'
        return
      endif
      let pkgsrc = DebGetPkgSrcName(line('.'))
      let listbugs_output = system('apt-listbugs -s ' . g:debchangelog_listbugs_severities . ' list ' . pkgsrc . ' | grep "^ #" 2> /dev/null')
      let bug_lines = split(listbugs_output, '\n')
    endif
    let completions = []
    for line in bug_lines
      let parts = matchlist(line, '^\s*\(#\S\+\)\s*-\s*\(.*\)$')
      let completion = {}
      let completion['word'] = parts[1]
      let completion['menu'] = parts[2]
      let completion['info'] = parts[0]
      let completions += [completion]
    endfor
    return completions
  endif
endfun

setlocal omnifunc=DebCompleteBugs

" }}}

" vim: set foldmethod=marker:
