" gitwildignore - Plugin for appending files in .gitignore to wildignore

if exists('g:loaded_gitwildignore')
  finish
endif
let g:loaded_gitwildignnore = 1

" Return a list of file patterns we want to ignore in the gitignore
" file parameter
function! Get_file_patterns(gitignore)
  let l:gitignore = fnamemodify(a:gitignore, ':p')
  let l:path = fnamemodify(a:gitignore, ':p:h')

  let l:file_patterns = []
  if !filereadable(l:gitignore)
    return l:file_patterns
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

    if (line =~ '^/')
      let l:file_patterns += [ l:path . l:file_pattern ]
    elseif (l:path =~ '^' . getcwd())
      let l:file_patterns += [ l:path . '/' . l:file_pattern, l:path . '/**/' . l:file_pattern ]
    else
      let l:file_patterns += [ l:file_pattern ]
    endif
  endfor

  return l:file_patterns
endfunction

" excludesfile defaults
let gitignore_files = [ '~/git/ignore', '~/.config/git/ignore' ]
let gitignore_files += split(system('git config core.excludesfile'), '\n')
let gitignore_files += split(system("git ls-files | grep '\.gitignore$'"), '\n')

let wildignore_file_patterns = []
for gitignore_file in gitignore_files
  let wildignore_file_patterns += Get_file_patterns(gitignore_file)
endfor

let execthis = 'set wildignore+=' . join(wildignore_file_patterns, ',')
execute execthis
