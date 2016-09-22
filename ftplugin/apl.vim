setl cms=⍝%s kmp=apl sw=2 ts=2 sts=2 cfu=apl#complete isk=@,48-57,_,^×,^÷
setl ai inde=APLIndent(v:lnum) indk+=0=~:andif,0=~:else,0=~:end,0=~:orif,0=~:until,0),0]
nn<buffer><silent> K           :cal apl#help()<cr>
nn<buffer><silent> <c-x><c-x>l :cal apl#localise()<cr>

if exists('*APLIndent')|fini|en
fu APLIndent(l)
 let p=prevnonblank(a:l-1)|let[a,b]=[getline(p),getline(a:l)]
 let re="\\v'[^']*'|⍝.*"|let[a,b]=[substitute(a,re,'','g'),substitute(b,re,'','g')] "rm comments and strings
 let r=a=~?'\v^\s*:(andif|class|else\a*|for|if|interface|namespace|orif|repeat|section|select|trap|while|with)>'
 let r-=b=~?'\v^\s*:(andif|else\a*|end\a*|orif|until)>'
 let r+=(a=~#'\v[\{\[\(]\s*$')-(b=~#'\v^\s*[\}\]\)]')
 retu indent(p)+s:sw()*r
endf
if exists('*shiftwidth')
 let s:sw=function('shiftwidth')
el
 fu s:sw()
  retu&sw
 endf
en
