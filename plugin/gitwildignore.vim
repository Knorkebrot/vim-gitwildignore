" gitwildignore - Plugin for appendng files in .gitignore to wildignore

if exists('g:loaded_gitwildignore')
  finish
endif
let g:loaded_gitwildignnore = 1

" Return a list of file patterns we want to ignore in the gitignore
" file parameter
function! Get_file_patterns(gitignore)
  let l:gitignore = fnamemodify(a:gitignore, ':p')
  let l:path = fnamemodify( a:gitignore, ':p:h')

  let l:file_patterns = []
  if filereadable(l:gitignore)
    " Parse each line according to http://git-scm.com/docs/gitignore
    " See PATTERN FORMAT
    for line in readfile(l:gitignore)
      let l:file_pattern = ''
      let l:prefix = '*/'
      if (line =~ '^/')
        let l:prefix = l:path
      endif
      if or(line =~ '^#', line == '')
        continue
      elseif line =~ '^!'
        " lines beginning with '!' are 'important' files and should be
        " included even if they were previously ignored
        " currently unimplemented
        continue
      elseif (line =~ '/$')
        let l:directory = substitute(line, '/$', '', '')
        let l:file_pattern = l:prefix . l:directory . '/*'
      else
        let l:file_pattern = l:prefix . line
      endif
      let l:file_pattern = substitute(l:file_pattern, ' ', '\\ ', 'g')
      let l:file_patterns += [ l:file_pattern ]
    endfor
  endif
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
