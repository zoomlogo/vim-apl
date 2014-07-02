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

if !has('gui_running') | fini | en
fu s:init()
  let k = 0 " counter for menu separators
  for s in readfile(expand('<sfile>:p:h').'/langbar')
    if len(s)
      let [c, d] = matchlist(s, '\v^(\S)\s*(.*)$')[1:2] " character and description
      let c1 = c == '&' ? '&&' : escape(c, '\\|.')
      let d1 = escape(d, ' ')
      let c2 = c == '|' ? '\|' : c
      exe 'inoremenu &APL.'.c1.'<tab>'.d1.' '.c2
    el
      exe 'inoremenu &APL.-apl'.k.'- :'
      let k += 1
    en
  endfor
endf
cal s:init()
delf s:init
