if exists('g:loaded_ctrlp_quickref') && g:loaded_ctrlp_quickref || v:version < 700 || &cp
    finish
endif
let g:loaded_ctrlp_quickref = 1

if !exists('g:ctrlp_quickref_func_dict')
    let g:ctrlp_quickref_func_dict = {}
endif

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

" TODO: Enable to change this tasks from outside.
fu! ctrlp#quickref#accept(mode, str)
    call ctrlp#exit()
    " When typing <Enter>
    if a:mode == 'e'
        call ctrlp#init(ctrlp#open#id(), { 'dir': a:str })
    " When typing <C-t>
    elseif a:mode == 't'
        silent exe 'cd '.a:str
    " When typing <C-v>
    elseif a:mode == 'v'
        silent exe 'cd '.a:str
    " When typing <C-x>
    elseif a:mode == 'h'
        silent exe 'e '.a:str
    endif
endf

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

fu! ctrlp#quickref#id()
    retu s:id
endf
