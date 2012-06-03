" Vim indent file
" Language:         reStructuredText Documentation Format
" Maintainer:       Nikolai Weibull <now@bitwi.se>
" Latest Revision:  2012-06-03

let s:keepcpo= &cpo
set cpo&vim
" if exists("b:did_rst_indent")
"   finish
" endif
let b:did_rst_indent = 1
setlocal indentexpr=GetRSTinIndent()
setlocal indentkeys=!^F,o,O
setlocal nosmartindent

" if exists("*GetRSTinIndent")
"   finish
" endif

" both bullet and enumerated list
" not support multibyte '•‣⁃'
let s:list_pattern = '\v\c^\s*%([-*+]|%(\d+|[#a-z]|[imcxv]+)[.)]|\(%(\d+|[#a-z]|[imcxv]+)\))\s+'

function! GetRSTinIndent()
  let lnum = prevnonblank(v:lnum - 1)
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)
  let line = getline(lnum)
  
  let l_ind = matchend(line, s:list_pattern)
  if l_ind != -1
      let ind += l_ind - matchend(line, '^\s*')
  endif

  let line = getline(v:lnum - 1)

  " Indent :FIELD: lines.  Don’t match if there is no text after the field or
  " if the text ends with a sent-ender.
   if line =~ '^:.\+:\s\{-1,\}\S.\+[^.!?:]$'
     return matchend(line, '^:.\{-1,}:\s\+')
   endif

  if line =~ '^\s*$'
    execute lnum
    call search('^\s*\%([-*+]\s\|\%(\d\+\|[#a-z]\|[imcxv]\+\)[.)]\s\|\.\.\|$\)', 'bW')
    let line = getline('.')
    let l_ind = matchend(line, s:list_pattern)
    if l_ind != -1
        let ind -= l_ind - matchend(line, '^\s*')
    elseif line =~ '^\s*\.\.'
        let ind -= 3
    endif
  endif

  return ind
endfunction
let &cpo = s:keepcpo
unlet s:keepcpo
