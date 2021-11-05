let s:sqgl=[] " information about all squiggles
let ht={}
for s in readfile(expand('<sfile>:p:r').'.txt')
    if s!~'^\s*#'&&s!~'^\s*$'
        let[c,t,d]=split(s,'\s*|\s*',1) "c:squiggle,t:type,d:description
        cal add(s:sqgl,[c,t,d])|if !has_key(ht,t)|let ht[t]=[]|en|cal add(ht[t],c)
    en
endfor
let g:apl#symbolsByType=ht

fu apl#complete(f,b) "f:findstart,b:base
    if a:f
        let s=getline('.')[:col('.')-2]
        let r='\v⎕[a-zA-Z]*$'                  |if s=~r|retu len(substitute(s,r,'',''))|en
        let r='\v((^|◇|⋄)\s*)@<=[:\)][a-zA-Z]*'|if s=~r|retu len(substitute(s,r,'',''))|en
    return-3
en
let s=tolower(a:b)|let l=len(s)-1
retu map(filter(copy(s:sqgl),'tolower(v:val[0][:l])==#s'),'{"word":v:val[0],"menu":v:val[2]}')
endf

let s:u={} "help urls
let s:uf=expand('<sfile>:p:h').'/urls'
fu apl#help()
    if empty(s:u)|for l in readfile(s:uf)|if l!~'^\s'&&l!=''|let[x,y]=split(l,"\t")|let s:u[x]=y|en|endfor|en
    let c=substitute(getline('.')[col('.')-1:],'\v^(.).*$','\1','') "char at cursor
    if has_key(s:u,c)|exe '!xdg-open '.shellescape(s:u['prefix'].s:u[c].s:u['suffix'],'%')
    el|echoh errormsg|ec 'no help available for '.c|echoh none|en
endf

fu apl#nameUnderCursor()
    let[s,n,k]=[getline('.'),col('.')-1,'[A-Z_a-zÀ-ÖØ-Ýß-öø-üþ∆⍙Ⓐ-Ⓩ0-9]']
    let l=substitute(strpart(s,0,n),'\v^.{-}('.k.'*)$','\1','')
    let r=substitute(strpart(s,n),  '\v^('.k.'*).{-}$','\1','')
    retu l.r
endf

fu apl#localise()
    let x=apl#nameUnderCursor()|let i=line('.')|wh i&&getline(i)!~'^\s*∇'|let i-=1|endw
    if !i|echoh errormsg|ec 'not inside a tradfn'|echoh none|retu|en
    let s=getline(i)|let s1=substitute(s,'\v\s*;\s*'.x.'\s*(;|$)','\1','')|cal setline(i,s==#s1 ? s.';'.x : s1)
endf

fu apl#ind(l)
    let p=prevnonblank(a:l-1)|let[a,b]=[getline(p),getline(a:l)]
    let re="\\v'[^']*'|⍝.*"|let[a,b]=[substitute(a,re,'','g'),substitute(b,re,'','g')] "rm comments and strings
    let r=a=~?'\v^\s*:(andif|class|else\a*|for|if|interface|namespace|orif|repeat|section|select|trap|while|with)>'
    let r-=b=~?'\v^\s*:(andif|else\a*|end\a*|orif|until)>'
    let r+=(a=~#'\v[\{\[\(]\s*$')-(b=~#'\v^\s*[\}\]\)]')
    let r+=(a=~#'^∇.')-(b=~#'^\s*∇\s*$')
    retu indent(p)+s:sw()*r
endf

if exists('*shiftwidth')
    let s:sw=function('shiftwidth')
el
    fu s:sw()
        retu&sw
    endf
en

if !has('gui_running')|fini|en
fu s:init(f) "f:language bar file
    let k=0 "counter for menu separators
    for s in readfile(a:f)
        if len(s)
            let[c,d]=matchlist(s,'\v^(\S)\s*(.*)$')[1:2] "character and description
            exe 'inoremenu &APL.'.(c=='&'?'&&':escape(c,'\\|.')).'<tab>'.(escape(d,' ')).' '.(c=='|'?'\|':c)
        el
            exe 'inoremenu &APL.-apl'.k.'- :'
            let k+=1
        en
    endfor
endf
cal s:init(expand('<sfile>:p:h').'/langbar')
