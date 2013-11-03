setlocal commentstring=⍝%s keymap=apl shiftwidth=2 tabstop=2 softtabstop=2

inoreabbrev <buffer> <silent> # <C-R>=<SID>HashBang()<CR>
function! <SID>HashBang()
    let ch = nr2char(getchar(0))
    return (ch ==# '!') ? "#!/usr/bin/env apl\<CR>\<CR>" : ('#' . ch)
endfunction
