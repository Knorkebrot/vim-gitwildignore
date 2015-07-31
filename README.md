vim-gitwildignore
=================

Install and every file/directory in your projects `.gitignore` files will be
appended to your wildignore. Useful when accompanied with the
[ctrlp.vim][ctrlp] plugin.

There's another [fork][fork] by @mikewadsten that may work better for you, but
it depends on other plugins while the original and this fork don't.

Changes
-------

- Support ignores that contain whitespace
- Support ignores that are relative to the gitignore's dir
- Use `git ls-files` for finding .gitignores
- Respect the user's excludesfile and it's defaults if not defined
- Local .gitignores apply to their directory

ToDo
----

- Support "unignored" paths (lines beginning with '!')


- - - - -

This is a fork of the original [vim-gitwildignore][orig] by zdwolfe.


[ctrlp]: https://github.com/kien/ctrlp.vim
[fork]: https://github.com/mikewadsten/vim-gitwildignore
[orig]: https://github.com/zdwolfe/vim-gitwildignore
