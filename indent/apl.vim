if exists('b:did_indent') | fini | en
let b:did_indent = 1

setl ai inde=APLIndent(v:lnum) indk+=0=~:andif,0=~:else,0=~:end,0=~:orif,0=~:until,0),0]

if exists('*APLIndent') | fini | en

if exists('*shiftwidth')
  let s:sw = function('shiftwidth')
el
  fu s:sw()
    retu &sw
  endf
en

fu APLIndent(l)
  let p = prevnonblank(a:l - 1)
  let [a, b] = [getline(p), getline(a:l)] " line above and line below (we're computing the latter's indent)
  let re = "\\v'[^']*'|⍝.*" " to remove comments and strings
  let [a, b] = [substitute(a, re, '', 'g'), substitute(b, re, '', 'g')]
  let r = a =~? '\v^\s*:(andif|class|else\a*|for|if|interface|namespace|orif|repeat|section|select|trap|while|with)>'
  let r -= b =~? '\v^\s*:(andif|else\a*|end\a*|orif|until)>'
  let r += (a =~# '\v[\{\[\(]\s*$') - (b =~# '\v^\s*[\}\]\)]')
  retu indent(p) + s:sw() * r
endf
