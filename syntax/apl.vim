if exists('b:current_syntax') | fini | en

sy case match

sy match  aplComment /[⍝#].*$/
sy match  aplStatementSeparator /[◇⋄]/
sy match  aplNumber /\v\c¯?(0x\x+|\d*\.?\d+(e[+¯]?\d+)?|¯|∞)(j¯?(0x\x+|\d*\.?\d+(e[+¯]?\d+)?|¯|∞))?/
sy match  aplNumberJ /\cj/ containedin=aplNumber " for complex number, separator between Re and Im
sy region aplString matchgroup=aplStringDelimiter start=/"/ end=/"/
sy region aplString matchgroup=aplStringDelimiter start=/'/ end=/'/
sy match  aplOperator /[\.\\\/⌿⍀¨⍣⍨⍠⍤∘]/
sy match  aplFunction /[+\-×÷⌈⌊∣|⍳?*⍟○!⌹<≤=>≥≠≡≢∊⍷∪∩~∨∧⍱⍲⍴,⍪⌽⊖⍉↑↓⊂⊃⌷⍋⍒⊤⊥⍕⍎⊣⊢⍁⍂≈⌸⍯↗]/
sy match  aplZilde /⍬/
sy match  aplIndex /[[\];]/
sy match  aplParen /[()]/

sy match  aplIdentifier /[A-Za-z_][A-Za-z_0-9]*/
sy match  aplIdentifier /[⎕⍞]/
sy match  aplQuadIdentifier /⎕[A-Za-z0-9]\+/
sy match  aplArrow /←/
if !exists('b:current_syntax') || b:current_syntax ==# 'apl'
  sy region aplEmbedded matchgroup=aplEmbeddedDelimiter start=/«/ end=/»/ contains=@aplJS
  sy include @aplJS syntax/javascript.vim
en

sy sync fromstart

com! -nargs=+ HL hi def link <args>
HL aplArrow               Statement
HL aplComment             Comment
HL aplEmbeddedDelimiter   Special
HL aplFunction            Function
HL aplIdentifier          Normal
HL aplIndex               Delimiter
HL aplZilde               Constant
HL aplNumber              Constant
HL aplNumberJ             Special
HL aplOperator            Type
HL aplParen               Delimiter
HL aplQuadIdentifier      Special
HL aplStatementSeparator  Statement
HL aplStringDelimiter     Delimiter
HL aplString              String

" Rainbow colouring for {⍺⍵}
let n = 10 " max nesting
for i in reverse(range(n))
  exe 'sy region aplB'.i.' matchgroup=aplL'.i.' start=/{/ end=/}/ contains=TOP,'.join(map(range(n), '"apl".("BL"[v:val>i]).v:val'), ',')
  exe 'sy match aplL'.(n - i - 1).' /[⍺⍵⍶⍹∇:]/'
  exe 'hi def link aplL'.i.' Special'
endfor

unl n i
delc HL
let b:current_syntax = 'apl'
