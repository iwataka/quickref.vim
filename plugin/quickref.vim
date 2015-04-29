com! Quickref cal quickref#start()
com! QuickrefLastDir cal quickref#start_at_last_dir()
com! QuickrefClearCache cal quickref#clear_cache()

if !exists('g:quickref_auto_detect')
  let g:quickref_auto_detect = 1
endif

augroup quickref
  autocmd!
  autocmd BufNew *
        \ if g:quickref_auto_detect && !getbufvar('%', '&readonly') |
          \ call quickref#add_path_to_cache() |
        \ endif
augroup END
