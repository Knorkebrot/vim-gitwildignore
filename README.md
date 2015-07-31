vim-gitwildignore
=================

Install and every file/directory in your projects `.gitignore` files will be
appended to your wildignore. Useful when accompanied with the
[ctrlp.vim][ctrlp] plugin.

There's a [fork][fork] by @mikewadsten that may work better for you, but it's
dependent on other plugins while the original (and this) one has none.

ToDo
----

Also parse the user's global gitignore. Currenty we only parse the local one.
We can get the path to the global one by:
```sh
git config core.excludesfile
```

... or ...

We could use something like this:
```sh
git ls-files --others --ignored --exclude-standard --directory
```
But that may be a regression, since this command only lists the paths that
have been there at the time, not the actually ignored paths. So if you start
vim and a new file appears that's ignored, it won't be in your wildignore.


[ctrlp]: https://github.com/kien/ctrlp.vim
[fork]: https://github.com/mikewadsten/vim-gitwildignore
