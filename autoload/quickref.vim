if exists('g:loaded_quickref') && g:loaded_quickref
  finish
endif
let g:loaded_quickref = 1

if !exists('g:quickref_readonly')
  let g:quickref_readonly = 1
endif

if !exists('g:quickref_open_extensions')
  let g:quickref_open_extensions = ['html', 'pdf']
endif

if !exists('g:quickref_cache_file')
  let g:quickref_cache_file = '~/.cache/quickref/path_list.txt'
endif

if !exists('g:quickref_include_rtp')
  let g:quickref_include_rtp = 1
endif

fu! quickref#start()
  if g:loaded_ctrlp
    call ctrlp#init(ctrlp#quickref#id())
  else
    echoe 'Quickref requires CtrlP!'
  endif
endfu

fu! quickref#start_at_last_dir()
  if g:loaded_ctrlp
    call ctrlp#quickref#last_dir()
  else
    echoe 'Quickref requires CtrlP!'
  endif
endfu

fu! quickref#path_list()
    let path_list = s:read_cache() + s:read_var()
    if g:quickref_include_rtp
        call extend(path_list, split(&rtp, ','))
    endif
    retu s:uniq(path_list)
endfu

fu! s:read_path_list(lines)
  let l:exclusive_paths = []
  let l:inclusive_paths = []
  for line in a:lines
    if line =~ '^!\s\?'
      let l:tmp_paths = split(expand(substitute(line, '^!\s\?', "", "")), '\n')
      call s:add_dirs(l:exclusive_paths, l:tmp_paths)
    elseif line !~ '^#' && line != ''
      let l:tmp_paths = split(expand(line), '\n')
      call s:add_dirs(l:inclusive_paths, l:tmp_paths)
    endif
  endfor
  let l:paths = []
  for path in l:inclusive_paths
    if !s:contains(exclusive_paths, path)
      call add(l:paths, path)
    endif
  endfor
  retu l:paths
endf

fu! s:read_cache()
  if filereadable(expand(g:quickref_cache_file))
    let l:lines = readfile(expand(g:quickref_cache_file))
    retu s:read_path_list(l:lines)
  el
    retu []
  endif
endf

fu! s:read_var()
  if exists('g:quickref_paths')
    retu s:read_path_list(g:quickref_paths)
  el
    retu []
  endif
endf

fu! s:add_dirs(list, paths)
  for path in a:paths
    if isdirectory(path)
      call add(a:list, path)
    endif
  endfor
endf

fu! s:contains(list, item)
  for i in a:list
    if i == a:item
      retu 1
    endif
  endfor
  retu 0
endf

fu! s:rest_items(list, idx)
  let result = []
  let i = a:idx
  let len = len(a:list)
  while i < len
    call add(result, get(a:list, i))
    let i = i + 1
  endwhile
  retu result
endfu

fu! quickref#check_ext(fname)
  let ext = fnamemodify(expand(a:fname), ':t:e')
  for e in g:quickref_open_extensions
    if ext == e
      retu 1
    endif
  endfor
  retu 0
endf

fu! s:uniq(list)
  let i = 0
  let len = len(a:list)
  let result = []
  while i < len - 1
    let item = get(a:list, i)
    let rest = s:rest_items(a:list, i + 1)
    if !s:contains(rest, item)
      call add(result, item)
    endif
    let i = i + 1
  endwhile
  retu result
endfu
