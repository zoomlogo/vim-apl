if !exists('main_syntax')
  if version < 600
    syntax clear
  elseif exists('b:current_syntax')
    finish
  endif
  let main_syntax = 'apl'
endif

syn case match

syn match aplWhitespace /\s\+/
syn match aplComment /[⍝#].*$/
syn match aplStatementSeparator /[◇⋄]/
syn match aplNumber /\v\c¯?(0x\x+|\d*\.?\d+(e[+¯]?\d+)?|¯)(j¯?(0x\x+|\d*\.?\d+(e[+¯]?\d+)?|¯))?/
syn match aplNumberJ /\cj/ containedin=aplNumber " for complex number, separator between Re and Im
syn region aplString matchgroup=aplStringDelimiter start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=aplStringSpecial
syn region aplString matchgroup=aplStringDelimiter start=/'/ skip=/\\\\\|\\'/ end=/'/ contains=aplStringSpecial
syn match aplStringSpecial /\\[0-7]\{1,3}\|\\x\x\x\|\\u[0-9A-Fa-f]\{4}\|\\./ contained
syn match aplOperator /[\.\\\/⌿⍀¨⍣⍨⍠⍤]/
syn match aplFunction /[+\-×÷⌈⌊∣|⍳?*⍟○!⌹<≤=>≥≠≡≢∊⍷∪∩~∨∧⍱⍲⍴,⍪⌽⊖⍉↑↓⊂⊃⌷⍋⍒⊤⊥⍕⍎⊣⊢⍁⍂≈⌸⍯]/
syn match aplFormalParameter /[⍺⍵]/
syn match aplNiladicFunction /⍬/
syn match aplIndex /[[\];]/
syn region aplParen matchgroup=aplParenDelimiter start=/(/ end=/)/ contains=ALL
syn region aplLambda matchgroup=aplLambdaDelimiter start=/{/ end=/}/ contains=ALL
syn match aplRecursion /∇/
syn match aplGuard /:/
syn match aplIdentifier /[A-Za-z_][A-Za-z_0-9]*/
syn match aplIdentifier /[⎕⍞]/
syn match aplArrow /←/
if !exists('b:current_syntax') || b:current_syntax ==# 'apl'
  syn region aplEmbedded matchgroup=aplEmbeddedDelimiter start=/«/ end=/»/ contains=@aplJS
  syn include @aplJS syntax/javascript.vim
endif

syn sync fromstart
syn sync maxlines=1000

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists('did_coffee_syn_inits')

  if version < 508
    let did_coffee_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink aplArrow               Statement
  HiLink aplComment             Comment
  HiLink aplEmbeddedDelimiter   Special
  HiLink aplFunction            Function
  HiLink aplFormalParameter     Special
  HiLink aplIdentifier          Normal
  HiLink aplIndex               Delimiter
  HiLink aplLambdaDelimiter     Special
  HiLink aplRecursion           Special
  HiLink aplGuard               Special
  HiLink aplNiladicFunction     Constant
  HiLink aplNumber              Constant
  HiLink aplNumberJ             Special
  HiLink aplOperator            Type
  HiLink aplParenDelimiter      Delimiter
  HiLink aplStatementSeparator  Statement
  HiLink aplStringDelimiter     Delimiter
  HiLink aplStringSpecial       Special
  HiLink aplString              String

  delcommand HiLink
endif

let b:current_syntax = 'apl'
if main_syntax == 'apl'
  unlet main_syntax
endif
