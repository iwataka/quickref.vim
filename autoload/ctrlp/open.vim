if exists('g:loaded_ctrlp_open') && g:loaded_ctrlp_open || v:version < 700 || &cp
    finish
endif
let g:loaded_ctrlp_open = 1

let s:open_command = ''
if has('unix')
    let s:open_command = 'xdg-open'
elsei has('win32unix')
    let s:open_command = 'cygstart'
elsei has('win32') || has('win64')
    let s:open_command = 'start'
elsei has('mac')
    let s:open_command = 'open'
endif

call add(g:ctrlp_ext_vars, {
    \ 'init': 'ctrlp#open#init()',
    \ 'accept': 'ctrlp#open#accept',
    \ 'type': 'path',
    \ 'sort': 0,
    \ 'specinput': 0,
    \ })

fu! ctrlp#open#init()
    let l:files = ctrlp#files()
    " If this is not here, the word 'Indexing...' is remained.
    cal ctrlp#progress('')
    retu l:files
endf

fu! ctrlp#open#accept(mode, str)
    if quickref#check_ext(a:str)
        call system(s:open_command.' '.a:str)
        call ctrlp#exit()
    el
        if g:quickref_readonly
            aug ctrlp-open
                au!
                au BufEnter *
                    \ setlocal readonly |
                    \ setlocal nomodifiable |
                    \ setlocal bufhidden=delete
            aug END
        endif
        call call('ctrlp#acceptfile', [a:mode, a:str])
        if exists("#ctrlp-open")
            au! ctrlp-open
        endif
    endif
endf

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

fu! ctrlp#open#id()
    retu s:id
endf
