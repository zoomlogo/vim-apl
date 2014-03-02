let s:allSymbols = []
let ht = {}
for line in readfile(expand('<sfile>:p:r').'.txt')
  if line !~ '^\s*#' && line !~ '^\s*$'
    let [symbol, t, description] = split(line, '\s*|\s*', 1)
    cal add(s:allSymbols, [symbol, t, description])
    if !has_key(ht, t) | let ht[t] = [symbol] | el | cal add(ht[t], symbol) | en
  en
endfor
let g:apl#symbolsByType = ht

fu apl#complete(findstart, base)
  if a:findstart
    let s = getline('.')[:col('.')-2]
    let re = '\v⎕[a-zA-Z]*$'
    if s =~ re | retu len(substitute(s, re, '', '')) | en
    let re = '\v((^|◇|⋄)\s*)@<=[:\)][a-zA-Z]*'
    if s =~ re | retu len(substitute(s, re, '', '')) | en
    return -3
  en
  let s = tolower(a:base)
  let l = len(s) - 1
  let r = filter(copy(s:allSymbols), 'tolower(v:val[0][:l])==#s')
  retu map(r, '{"word":v:val[0],"menu":v:val[2]}')
endf

fu apl#hashbang()
  let ch = nr2char(getchar(0))
  retu ch=='!' ? "#!/usr/bin/env apl\<cr>\<cr>" : ('#'.ch)
endf
