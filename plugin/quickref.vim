com! Quickref cal quickref#start()
com! QuickrefLastDir cal quickref#start_at_last_dir()
com! QuickrefClearCache cal quickref#clear_cache()
com! -nargs=* -complete=dir QuickrefAdd cal quickref#add_path_to_cache(<f-args>)
com! -nargs=* -complete=dir QuickrefRemove cal quickref#remove_path_from_cache(<f-args>)
com! -nargs=0 QuickrefDisplayCache cal quickref#display_cache()

if !exists('g:quickref_auto_detect')
  let g:quickref_auto_detect = 1
endif

augroup quickref
  autocmd!
  autocmd BufNew *
        \ if g:quickref_auto_detect && !getbufvar('%', '&readonly') |
          \ call quickref#auto_detect() |
        \ endif
augroup END
