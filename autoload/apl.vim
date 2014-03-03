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

let s:u = {} " help URLs
let s:uf = expand('<sfile>:p:h').'/urls'
fu apl#help()
  if empty(s:u)
    for l in readfile(s:uf)
      if l !~ '^\s' && l != ''
        let [x, y] = split(l, "\t")
        let s:u[x] = y
      en
    endfor
  en
  let c = substitute(getline('.')[col('.')-1:], '\v^(.).*$', '\1', '') " char at cursor
  if has_key(s:u, c)
    exe '!gnome-www-browser '.shellescape(s:u['prefix'].s:u[c].s:u['suffix'], '%')
  el
    echoh errormsg | ec 'no help available for '.c | echoh none
  en
endf

fu apl#identifierUnderCursor()
  let [s, n, k] = [getline('.'), col('.')-1, '[A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ0-9]']
  let l = substitute(strpart(s, 0, n), '\v^.{-}('.k.'*)$', '\1', '')
  let r = substitute(strpart(s, n),    '\v^('.k.'*).{-}$', '\1', '')
  retu l.r
endf

fu apl#localise()
  let x = apl#identifierUnderCursor()
  let i = line('.') | wh i && getline(i) !~ '^\s*∇' | let i = i - 1 | endw
  if !i | echoh errormsg | ec 'not inside a tradfn' | echoh none | retu | en
  let s = getline(i)
  let s1 = substitute(s, '\v\s*;\s*'.x.'\s*(;|$)', '\1', '')
  cal setline(i, s==#s1 ? s.';'.x : s1)
endf
