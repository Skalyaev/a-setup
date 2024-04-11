"===================================== WINDOWS
nnoremap <leader>w :w <CR>
nnoremap <leader>W :wa <CR>
nnoremap <leader>q :q <CR>
nnoremap <leader>Q :qa <CR>
nnoremap <leader>x :x <CR>
nnoremap <leader>X :xa <CR>

"===================================== NAVIGATION
nnoremap <leader>o :on <CR>
nnoremap <leader>O :on! <CR>

nnoremap <leader>e :e# <CR>

nnoremap <leader>& :e ~/.local/share/git <CR>
nnoremap <leader>é :e ~/setup/ui/misc/bin <CR>
nnoremap <leader>" :e ~/setup/ui/ide/templates <CR>

nnoremap <leader>1 :e ~/.vim/binds.vim <CR>
nnoremap <leader>2 :e ~/.vim/plugged/a-vim-theme/colors/neon.vim <CR>
nnoremap <leader>3 :e ~/.vimrc <CR>

nnoremap <leader>4 :e ~/.bash_aliases <CR>
nnoremap <leader>5 :e ~/.inputrc <CR>
nnoremap <leader>6 :e ~/.config/alacritty/alacritty.yml <CR>

nnoremap <leader>7 :e ~/.local/share/jgmenu/set/main <CR>
nnoremap <leader>8 :e ~/.config/i3 <CR>
nnoremap <leader>9 :e ~/setup/ui <CR>

"===================================== MISC
vnoremap <leader>c "+y
nnoremap <leader>, :echo synIDattr(synID(line("."), col("."), 1), "name") <CR>

"===================================== ADDONS
nnoremap <leader>d :NERDTreeToggle <CR>
nnoremap <leader>D :NERDTreeFocus <CR>
