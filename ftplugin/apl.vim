setlocal commentstring=⍝%s keymap=dyalog completefunc=apl#complete iskeyword=@,48-57,_,^×,^÷
setlocal autoindent indentexpr=apl#ind(v:lnum) indentkeys+=0=~:andif,0=~:else,0=~:end,0=~:orif,0=~:until,0),0]
nnoremap <buffer><silent> K           :cal apl#help()<cr>
nnoremap <buffer><silent> <c-x><c-x>l :cal apl#localise()<cr>
