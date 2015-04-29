com! Quickref cal quickref#start()
com! QuickrefLastDir cal quickref#start_at_last_dir()

augroup quickref
  autocmd!
  autocmd BufNew * call quickref#add_path_to_cache()
augroup END
