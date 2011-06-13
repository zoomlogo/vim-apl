setlocal commentstring=⍝%s
setlocal keymap=apl

inoreabbrev <buffer> <silent> # <C-R>=<SID>HashBang()<CR>
function! <SID>HashBang()
    let ch = nr2char(getchar(0))
    return (ch ==# '!') ? "#!/usr/bin/env apl\<CR>\<CR>" : ('#' . ch)
endfunction
