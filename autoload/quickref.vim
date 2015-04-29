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

if !exists('g:quickref_root_markers')
  let g:quickref_root_markers = ['.git', '.hg', '.svn', '.bzr', '_darcs']
endif

if !exists('g:quickref_paths')
  let g:quickref_paths = []
endif

if !exists('g:quickref_auto_detect_depth')
  let g:quickref_auto_detect_depth = -1
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
    let path_list = s:validate(s:readcache()) + s:read_var()
    echom string(path_list)
    if g:quickref_include_rtp
        call extend(path_list, split(&rtp, ','))
    endif
    retu s:uniq(path_list)
endfu

fu! s:read_path_list(lines)
  let exclusives = []
  let paths = []
  for line in a:lines
    if line =~ '^\s\?!\s\?'
      call s:add_dirs(exclusives, s:validate(substitute(line, '^\s\?!\s\?', '', '')))
    elseif line != ''
      call s:add_dirs(paths, s:validate(line))
    endif
  endfor
  call s:remove(paths, exclusives)
  retu paths
endf

fu! s:read_var()
  if exists('g:quickref_paths')
    retu s:read_path_list(g:quickref_paths)
  el
    retu []
  endif
endf

fu! quickref#check_ext(fname)
  let ext = fnamemodify(expand(a:fname), ':t:e')
  retu index(g:quickref_open_extensions, ext) != -1
endf

fu! s:detect_root_upward(fname)
  let dir = fnamemodify(expand(a:fname), ':p:h')
  for mark in g:quickref_root_markers
    let rdir = finddir(mark, dir.';')
    if !empty(rdir)
      retu fnamemodify(rdir, ':h')
    endif
  endfor
  retu ''
endfu

fu! s:detect_root_downward(dir, depth)
  let dir = a:dir =~ '/$' ? a:dir : a:dir.'/'
  for mark in g:quickref_root_markers
    let rdir = finddir(mark, dir.'**'.a:depth)
    if !empty(rdir)
      retu fnamemodify(rdir, ':h')
    endif
  endfor
  retu ''
endfu

fu! quickref#auto_detect()
  let fname = expand('%')
  let root = fnamemodify(expand(s:detect_root_upward(fname)), ':p')
  if !empty(root)
    call s:add_to_cache(root)
    if g:quickref_auto_detect_depth >= 0
      call s:add_neighbor_roots_to_cache(root)
    endif
  endif
endfu

fu! s:neighbor_roots(path)
  let upper_dir = s:parent(a:path)
  let result = []
  if !empty(upper_dir)
    let paths = split(glob(upper_dir.'/*'), '\n')
    for p in paths
      if isdirectory(p)
        let root = s:detect_root_downward(p, g:quickref_auto_detect_depth)
        let root = fnamemodify(expand(root), ':p')
        if !empty(root)
          call add(result, root)
        endif
      endif
    endfor
  endif
  retu result
endfu

fu! quickref#clear_cache()
  if filereadable(expand(g:quickref_cache_file))
    call s:writecache([])
  endif
endfu

fu! quickref#add_path_to_cache(...)
  if a:0 > 0
    call s:add_to_cache(a:000)
  else
    call s:add_to_cache(getcwd())
  endif
endfu

fu! quickref#remove_path_from_cache(...)
  if a:0 > 0
    call s:remove_from_cache(a:000)
  else
    call s:remove_from_cache(getcwd())
  endif
endfu

fu! quickref#display_cache()
  let paths = s:readcache()
  for p in paths
    echom p
  endfor
endfu

" Writes given paths to the cache file with automatically making the directory.
" This name is derived from writefile() function.
fu! s:writecache(paths)
  let dir = fnamemodify(expand(g:quickref_cache_file), ':p:h')
  if !isdirectory(dir)
    if exists('*mkdir')
      call mkdir(dir, 'p')
    else
      silent! exe '!mkdir -p '.dir
    endif
  endif
  call writefile(a:paths, expand(g:quickref_cache_file))
endfu

" Reads the cache file if it exists, otherwise returns empty list.
" This name is derived from readfile() function.
fu! s:readcache()
  if filereadable(expand(g:quickref_cache_file))
    retu readfile(expand(g:quickref_cache_file))
  el
    retu []
  endif
endf

" Adds a path/paths to the cache file.
fu! s:add_to_cache(path)
  let lines = s:readcache()
  let path = s:validate(a:path)
  call s:add(lines, path)
  call s:writecache(lines)
endfu

" Removes a path/paths from the cache file.
fu! s:remove_from_cache(path)
  let lines = s:readcache()
  let path = s:validate(a:path)
  call s:remove(lines, path)
  call s:writecache(lines)
endfu

" Adds an item/items to specified list.
fu! s:add(list, item)
  if type(a:item) == type([])
    for i in a:item
      call s:add(a:list, i)
    endfor
  else
    call add(a:list, a:item)
  endif
endfu

" Removes an item/items from specified list.
fu! s:remove(list, item)
  if type(a:item) == type([])
    for i in a:item
      call s:remove(a:list, i)
    endfor
  else
    let idx = index(a:list, a:item)
    if idx != -1
      call remove(a:list, idx)
    endif
  endif
endfu

fu! s:validate(path)
  retu map(s:resolve(s:expand(a:path)), "v:val =~ '/$' ? v:val : v:val.'/'")
endfu

" Expands a path/paths.
fu! s:expand(path)
  if type(a:path) == type('')
    retu split(expand(a:path), '\n')
  elseif type(a:path) == type([])
    let result = []
    for p in a:path
      call extend(result, s:expand(p))
    endfor
    retu result
  endif
endfu

" Resolves a path/paths
fu! s:resolve(path)
  if type(a:path) == type('')
    retu resolve(a:path)
  elseif type(a:path) == type([])
    let result = []
    for p in a:path
      call add(result, s:resolve(p))
    endfor
    retu result
  endif
endfu

" Returns a list whose elements are unique.
fu! s:uniq(list)
  let result = []
  for i in range(len(a:list))
    let item = get(a:list, i)
    if index(a:list, item, i + 1) == -1
      call add(result, item)
    endif
  endfor
  retu result
endfu

" Adds directories in a path/paths to specified list.
fu! s:add_dirs(list, path)
  if type(a:path) == type('')
    if isdirectory(a:path)
      call add(a:list, a:path)
    endif
  elseif type(a:path) == type([])
    for p in a:path
      call s:add_dirs(a:list, p)
    endfor
  endif
endf

" Returns the parent directory of a given path.
" If it doesn't exist, returns empty string.
fu! s:parent(path)
  let fullpath = fnamemodify(a:path, ':p')
  if fullpath == '/'
    retu ''
  else
    let p = substitute(fullpath, '/$', '', '')
    retu fnamemodify(p, ':h')
  endif
endfu
