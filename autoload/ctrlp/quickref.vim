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
    let path_list = quickref#read_cache() + quickref#read_var()
    if g:quickref_include_rtp
        retu path_list + split(&rtp, ',')
    else
        retu path_list
    endif
endf

fu! ctrlp#quickref#accept(mode, str)
    call ctrlp#exit()
    let s:last_dir = a:str
    call ctrlp#init(ctrlp#open#id(), { 'dir': a:str })
endf

fu! ctrlp#quickref#last_dir()
    call ctrlp#init(ctrlp#open#id(), { 'dir': s:last_dir })
endfu

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

fu! ctrlp#quickref#id()
    retu s:id
endf
