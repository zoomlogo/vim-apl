setl cms=⍝%s kmp=apl sw=2 ts=2 sts=2

inorea <buffer> <silent> # <c-r>=<sid>hb()<cr>
fu! s:hb()
  let ch = nr2char(getchar(0))
  retu ch ==# '!' ? "#!/usr/bin/env apl\<cr>\<cr>" : ('#'.ch)
endf
