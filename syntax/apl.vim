if exists('b:current_syntax')|fini|en
"APL names: [A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ]
sy case match
sy match aplerr /[(){}\[\]]/
sy match aplsep /[◇⋄]/
sy region aplstr start=/"/ end=/"/
sy region aplstr matchgroup=aplstr start=/'/rs=s+1 skip=/''/ end=/'/re=e-1 contains=aplquo oneline
sy match aplquo /''/ contained
sy match apladv /[\\\/⌿⍀¨⍨⌶&∥⌸]/
sy match aplcnj /[.@∘⍠⍣⍤]/
sy match aplvrb /[+\-×÷⌈⌊∣|⍳⍸?*⍟○!⌹<≤=>≥≠≡≢∊⍷∪∩~∨∧⍱⍲⍴,⍪⌽⊖⍉↑↓⊂⊃⊆⊇⌷⍋⍒⊤⊥⍕⍎⊣⊢⍁⍂≈⍯↗¤→]/
sy match aplcns /[⍬⌾#]/
sy match aplind /[[\];]/
sy match aplpar /[()]/
sy match aplnum /\v\c¯?(0x\x+|\d*\.?\d+(e[+¯]?\d+)?|¯|∞)(j¯?(0x\x+|\d*\.?\d+(e[+¯]?\d+)?|¯|∞))?/
sy match aplidn /[A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ][A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ0-9]*/
sy match aplqid /[⎕⍞]/
sy match apllbl /[A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ][A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ0-9]*:/

"rainbow colouring for {⍺⍵}
let n=10 "max nesting
for i in reverse(range(n))
 exe 'sy region aplB'.i.' matchgroup=aplL'.i.' start=/{/ end=/}/ contains=TOP,apllbl,'.join(map(range(n),'"apl".("BL"[v:val>i]).v:val'),',')
 exe 'sy match aplL'.(n-i-1).' /[⍺⍵⍶⍹∇⍫:]/'
 exe 'hi def link aplL'.i.' Special'
endfor
unl n i

sy match aplerr /\v⎕[A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ0-9]+/
sy match aplerr /\v((^|◇|⋄)\s*)@<=[:\)][A-Za-z]+/
sy match aplkwd /\c:in\>/

let ht=apl#symbolsByType
for [t,hl] in [['N','cns'],['n','qid'],['v','vrb'],['a','adv'],['c','cnj']]
 if has_key(ht, t)
  exe 'sy match apl'.hl.' /\v\c⎕('.join(map(filter(copy(ht[t]), 'v:val=~"^⎕"'), 'substitute(v:val,"^⎕","","")'), '|').')>/'
 en
endfor
exe 'sy match aplkwd /\v\c((^|◇|⋄)\s*)@<=:('.join(map(copy(ht.k),'substitute(v:val,"^:","","")'),'|').')>/'
exe 'sy match aplcmd /\v\c((^|◇|⋄)\s*)@<=\)('.join(map(ht[')0']+ht[')1']+ht[')2'],'substitute(v:val,"^\)","","")'),'|').')>.*$/'
unl ht t hl

sy match aplarw /←/
if !exists('b:current_syntax')||b:current_syntax==#'apl'
 sy region aplemb matchgroup=aplglm start=/«/ end=/»/ contains=@apljs
 sy include @apljs syntax/javascript.vim
en

sy match aplcom /\v(⍝| # |^#[! ]).*$/
sy match aplcom /^#!\/bin\/bash\n.*$/

sy sync fromstart
com! -nargs=+ H hi def link <args>
H apladv type
H aplarw statement
H aplcom comment
H aplcnj operator
H aplcns constant
H aplglm special
H aplerr error
H aplidn normal
H aplind delimiter
H aplkwd statement
H apllbl special
H aplnum number
H aplpar delimiter
H aplqid identifier
H aplsep statement
H aplstr string
H aplquo specialchar
H aplcmd preproc
H aplvrb function
delc H
let b:current_syntax='apl'
