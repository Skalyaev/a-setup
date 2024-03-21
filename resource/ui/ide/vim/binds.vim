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
nnoremap <leader>& :e ~/setup/ui <CR>
nnoremap <leader>é :e ~/setup/ui/tools/bin <CR>
nnoremap <leader>" :e ~/setup/ui/ide/templates <CR>

nnoremap <leader>1 :e ~/.bash_aliases <CR>
nnoremap <leader>2 :e ~/.inputrc <CR>
nnoremap <leader>3 :e ~/.config/terminator/config <CR>
nnoremap <leader>4 :e ~/.vim/binds.vim <CR>
nnoremap <leader>5 :e ~/.vim/plugged/a-vim-theme/colors/neon.vim <CR>
nnoremap <leader>6 :e ~/.vimrc <CR>
nnoremap <leader>7 :e ~/.config/i3/binds.conf <CR>
nnoremap <leader>8 :e ~/.config/i3/config <CR>

"===================================== MISC
vnoremap <leader>c "+y
nnoremap <leader>, :echo synIDattr(synID(line("."), col("."), 1), "name") <CR>

"===================================== ADDONS
nnoremap <leader>f :Autoformat <CR>
nnoremap <leader>d :NERDTreeToggle <CR>
nnoremap <leader><C-d> :NERDTreeFocus <CR>
