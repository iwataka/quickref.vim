if exists('g:loaded_ctrlp_quickref') && g:loaded_ctrlp_quickref || v:version < 700 || &cp
    finish
endif
let g:loaded_ctrlp_quickref = 1

call add(g:ctrlp_ext_vars, {
    \ 'init': 'ctrlp#quickref#init()',
    \ 'accept': 'ctrlp#quickref#accept',
    \ 'type': 'path',
    \ 'sort': 0,
    \ 'specinput': 0,
    \ })

fu! ctrlp#quickref#init()
    retu quickref#path_list()
endf

fu! ctrlp#quickref#accept(mode, str)
    call ctrlp#exit()
    if a:mode == 't'
        silent exe 'cd '.a:str
    else
        let s:last_dir = a:str
        call ctrlp#init(ctrlp#open#id(), { 'dir': a:str })
    endif
endf

fu! ctrlp#quickref#last_dir()
    call ctrlp#init(ctrlp#open#id(), { 'dir': s:last_dir })
endfu

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

fu! ctrlp#quickref#id()
    retu s:id
endf
