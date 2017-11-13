" Title: vim-syncr
" Description: Upload/download/delete files and directories with rsync
" Usage: :VsUpload, VsDownload and :VsDelete
"        Mapped to
"        <leader>vsu (vim-syncr upload)
"        <leader>vsdel (vim-syncr delete)
"        <leader>vsd (vim-syncr download)
"        See README for more
" Github: https://github.com/s10g/vim-syncr
" Author: Stig
" License: MIT

function! VS_GetConf()
  let conf = {}

  let l_configpath = expand('%:p:h')
  let l_configfile = l_configpath . '/.syncr'
  let l_foundconfig = ''
  if filereadable(l_configfile)
    let l_foundconfig = l_configfile
  else
    while !filereadable(l_configfile)
      let slashindex = strridx(l_configpath, '/')
      if slashindex >= 0
        let l_configpath = l_configpath[0:slashindex]
        let l_configfile = l_configpath . '.syncr'
        let l_configpath = l_configpath[0:slashindex-1]
        if filereadable(l_configfile)
          let l_foundconfig = l_configfile
          break
        endif
        if slashindex == 0 && !filereadable(l_configfile)
          break
        endif
      else
        break
      endif
    endwhile
  endif

  if strlen(l_foundconfig) > 0
    let options = readfile(l_foundconfig)
    for i in options
      let vname = substitute(i[0:stridx(i, ' ')], '^\s*\(.\{-}\)\s*$', '\1', '')
      let vvalue = escape(substitute(i[stridx(i, ' '):], '^\s*\(.\{-}\)\s*$', '\1', ''), "%#!")
      let conf[vname] = vvalue
    endfor
  endif

  return conf
endfunction


function! VS_UploadFiles()
  let conf = VS_GetConf()

  if has_key(conf, 'remote_host')
        let cmd = "rsync -avzhe ssh " . conf['project_path'] . " " . conf['remote_user'] . "@" . conf['remote_host'] . ":" . conf['remote_path'] . " --exclude '.*'"
        execute '!' . cmd
  else
    echo 'Could not locate a .syncr configuration file. Aborting...'
  endif
endfunction


function! VS_DeleteFiles()
  let conf = VS_GetConf()

  if has_key(conf, 'remote_host')
        let cmd = "rsync -avzhe ssh " . conf['project_path'] . " " . conf['remote_user'] . "@" . conf['remote_host'] . ":" . conf['remote_path'] . " --exclude '.*'" . " --delete"
        execute '!' . cmd
  else
    echo 'Could not locate a .syncr configuration file. Aborting...'
  endif
endfunction


function! VS_DownloadFiles()
  let conf = VS_GetConf()

  if has_key(conf, 'remote_host')
        let cmd = "rsync -avzhe ssh " . conf['remote_user'] . "@" . conf['remote_host'] . ":" . conf['remote_path']  . " " . conf['project_path'] . " --exclude '.*'" 
        execute '!' . cmd
  else
    echo 'Could not locate a .syncr configuration file. Aborting...'
  endif
endfunction

command! VsUpload call VS_UploadFiles()
command! VsDelete call VS_DeleteFiles()
command! VsDownload call VS_DownloadFiles()

nmap <leader>vsu :VsUpload<Esc>
nmap <leader>vsdel :VsDelete<Esc>
nmap <leader>vsd :VsDelete<Esc>
