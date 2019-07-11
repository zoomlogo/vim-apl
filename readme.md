### Notes on usage
* rainbow curly braces with a matching colour for `⍺`, `⍵`, `∇`, and `:`
* use backquote as a prefix key, e.g. ``` `i ``` for `⍳`, ``` `r ``` for `⍴` (configurable through `g:apl_prefix_key`)
* `<c-x><c-u>` completion for quad names, keywords, and system commands

### Installation with Vundle

* If necessary, [setup Vundle]
* Add `Plugin https://gitlab.com/n9n/vim-apl.git` to `.vimrc`:

	`
	call vundle#begin()
	  Plugin 'VundleVim/Vundle.vim'
	  Plugin 'https://gitlab.com/n9n/vim-apl.git'
	call vundle#end()
	`

* Save `.vimrc` and run `vim +PluginInstall +qall`

[setup Vundle]: https://github.com/VundleVim/Vundle.vim#quick-start
