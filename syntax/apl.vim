if exists('b:current_syntax')|fini|en
"APL names: [A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ]
syntax case match
syntax match aplerr /[(){}\[\]]/
syntax match aplsep /⋄/
syntax region aplstr start=/"/ end=/"/
syntax region aplstr matchgroup=aplstr start=/'/rs=s+1 skip=/''/ end=/'/re=e-1 contains=aplquo oneline
syntax match aplquo /''/ contained
syntax match apladv /[\\\/⌿⍀¨⍨⌶&∥⌸]/
syntax match aplcnj /[.@∘⍠⍣⍤⍥⌺]/
syntax match aplvrb /[+\-×÷⌈⌊∣|⍳⍸?*⍟○!⌹<≤=>≥≠≡≢∊⍷∪∩~∨∧⍱⍲⍴,⍪⌽⊖⍉↑↓⊂⊃⊆⊇⌷⍋⍒⊤⊥⍕⍎⊣⊢⍁⍂≈⍯↗¤→]/
syntax match aplcns /[⍬⌾#]/
syntax match aplind /[[\];]/
syntax match aplpar /[()]/
syntax match aplnum /\v\c¯?(\d*\.?\d+(e[+¯]?\d+)?|¯|∞)(j¯?(\d*\.?\d+(e[+¯]?\d+)?|¯|∞))?/
syntax match aplidn /[A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ][A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ0-9]*/
syntax match aplqid /[⎕⍞]/
syntax match apllbl /[A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ][A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ0-9]*:/

"rainbow colouring for {⍺⍵}
let n=10 "max nesting
for i in reverse(range(n))
    exec 'syntax region aplB'.i.' matchgroup=aplL'.i.' start=/{/ end=/}/ contains=TOP,apllbl,'.join(map(range(n),'"apl".("BL"[v:val>i]).v:val'),',')
    exec 'syntax match aplL'.(n-i-1).' /[⍺⍵⍶⍹∇⍫:]/'
    exec 'hi def link aplL'.i.' Special'
endfor
unl n i

syntax match aplerr /\v⎕[A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ0-9]+/
syntax match aplerr /\v((^|⋄)\s*)@<=[:\)][A-Za-z]+/
syntax match aplkwd /\c:in\>/

let ht=apl#symbolsByType
for [t,hl] in [['N','cns'],['n','qid'],['v','vrb'],['a','adv'],['c','cnj']]
    if has_key(ht, t)
        exe 'syntax match apl'.hl.' /\v\c⎕('.join(map(filter(copy(ht[t]), 'v:val=~"^⎕"'), 'substitute(v:val,"^⎕","","")'), '|').')>/'
    en
endfor
exe 'syntax match aplkwd /\v\c((^|⋄)\s*)@<=:('.join(map(copy(ht.k),'substitute(v:val,"^:","","")'),'|').')>/'
exe 'syntax match aplcmd /\v\c((^|⋄)\s*)@<=\)('.join(map(ht[')0']+ht[')1']+ht[')2'],'substitute(v:val,"^\)","","")'),'|').')>.*$/'
unl ht t hl

syntax match aplarw /←/
if !exists('b:current_syntax')||b:current_syntax==#'apl'
    syntax region aplemb matchgroup=aplglm start=/«/ end=/»/ contains=@apljs
    syntax include @apljs syntax/javascript.vim
en

syntax match aplcom /\v(⍝| # |^#[! ]).*$/
syntax match aplcom /^#!\/bin\/bash\n.*$/

syntax sync fromstart
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

" Set the current buffer syntax to apl
let b:current_syntax='apl'
