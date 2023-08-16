call plug#begin()
Plug 'junegunn/vim-easy-align'
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
call plug#end()

" File tree browser - backslash
map \ :NERDTreeToggle<CR>
" File tree browser showing current file - pipe (shift-backslash)
map \| :NERDTreeFind<CR>

