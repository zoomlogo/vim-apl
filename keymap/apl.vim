scripte utf-8
let b:keymap_name = expand('<sfile>:t:r')

let a  = '`1234567890-= ~!@#$%^&*()_+'
let a .= 'qwertyuiop[]  QWERTYUIOP{} '
let a .= 'asdfghjkl;''\ ASDFGHJKL:"| '
let a .= 'zxcvbnm,./    ZXCVBNM<>?   '

let b  = '`¨¯<≤=≥>≠∨∧÷× ⍨∞⍁⍂⍠≈⌸⍯⍣⍱⍲≢≡'
let b .= 'q⍵∊⍴~↑↓⍳○⍟←→  ⌹⍹⍷⍤T⌶⊖⍸⍬⌽⊣⊢ '
let b .= '⍺⌈⌊f∇∆∘k⎕⋄''⍀ ⍶SDF⍒⍋⍝K⍞:"⍉ '
let b .= '⊂⊃∩∪⊥⊤∣⍪.⌿    ⊆⊇⋔⍦⍎⍕⌷«»↗   '

let [A, B] = map([a, b], "split(v:val,'\\zs *')")
for i in range(len(A)) | exe escape('ln<buffer>`'.A[i].' '.B[i], '|\') | endfor
unl a b A B i
