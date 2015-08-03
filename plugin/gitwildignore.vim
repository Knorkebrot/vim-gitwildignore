" gitwildignore - Plugin for appending files in .gitignore to wildignore/

if exists('g:loaded_gitwildignore')
  finish
endif
let g:loaded_gitwildignnore = 1

" Collect gitignore global files
" excludesfile defaults
let s:gitignore_globals = [ expand('~/git/ignore'), expand('~/.config/git/ignore') ]
" excludesfile user defined
let s:gitignore_globals += [ expand(substitute(system('git config core.excludesfile'), '\n\+$', '', '')) ]

function! Is_global_file(file)
  let l:is_global = 0
  for f in s:gitignore_globals
    if a:file == f
      let l:is_global = 1
    endif
  endfor
  return l:is_global
endfunction

" Return a list of file patterns we want to ignore in the gitignore
" file parameter
function! Get_file_patterns(gitignore)
  let l:gitignore = fnamemodify(a:gitignore, ':p')
  let l:path = fnamemodify(a:gitignore, ':p:h')

  let l:ret = []
  if !filereadable(l:gitignore)
    return l:ret
  endif

  if l:path =~ "/.git/info$"
    let l:path = fnamemodify(fnamemodify(l:path, ':h'), ':h')
  endif

  " Parse each line according to http://git-scm.com/docs/gitignore
  " See PATTERN FORMAT
  for line in readfile(l:gitignore)
    let l:file_pattern = ''
    if or(line =~ '^#', line == '')
      continue
    elseif line =~ '^!'
      " lines beginning with '!' are 'important' files and should be
      " included even if they were previously ignored
      " currently unimplemented
      continue
    elseif (line =~ '/$')
      let l:directory = substitute(line, '/$', '', '')
      let l:file_pattern = l:directory . '/*'
    else
      let l:file_pattern = line
    endif
    let l:file_pattern = substitute(l:file_pattern, '\s', '\\\0', 'g')

    let l:is_global = Is_global_file(l:gitignore)

    if l:is_global == 1
      let l:ret += [ l:file_pattern ]
    elseif line =~ '^/'
      let l:ret += [ l:path . l:file_pattern ]
    elseif l:path =~ '^' . getcwd()
      let l:ret += [ l:path . '/' . l:file_pattern, l:path . '/**/' . l:file_pattern ]
    else
      let l:ret += [ l:file_pattern ]
    endif
  endfor

  return l:ret
endfunction

" Check if we're in a git repository and if we are, search for .gitignores
" and the local exclude file
function! Get_local_gitignores()
  let l:ret = []
  let l:gitroot = system('git rev-parse --show-toplevel')
  if l:gitroot =~ '^fatal: '
    return l:ret
  endif
  let l:gitroot = substitute(l:gitroot, '\n', '', '')
  let l:ret += [ l:gitroot . '/.git/info/exclude' ]
  let l:ret += split(system("git ls-files | grep '\.gitignore$'"), '\n')
  return l:ret
endfunction

" concat global and local gitignores
let gitignore_files = s:gitignore_globals
let gitignore_files += Get_local_gitignores()

let wildignore_file_patterns = []
for gitignore_file in gitignore_files
  let wildignore_file_patterns += Get_file_patterns(gitignore_file)
endfor

let execthis = 'set wildignore+=' . join(wildignore_file_patterns, ',')
execute execthis
