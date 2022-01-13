" Automate vim-plug installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Replacement for nvim-tree
Plug 'preservim/nerdtree'

" Replacement for Comment.nvim
Plug 'tpope/vim-commentary'

" Replacement for Telescope (requires fzf installed on system)
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" --- Settings ---

" Set tab size to 2 spaces
set expandtab       " Use spaces instead of tabs
set shiftwidth=2    " Number of spaces to use for each step of (auto)indent
set tabstop=2       " Number of spaces that a <Tab> counts for
set softtabstop=2   " Number of spaces that a <Tab> counts for while editing

" Set Ctrl + d and Ctrl + u to jump 10 lines
set scroll=10

" Enable undo history between sessions
set undofile
set undodir=~/.vim/undo
if !isdirectory(&undodir)
    call mkdir(&undodir, "p")
endif

" Use system clipboard
set clipboard=unnamedplus

" Enable relative line numbers
set relativenumber
set number          " Show absolute line number for the current line

" --- Keymaps ---

" Clear search highlighting
nnoremap <silent> ? :nohlsearch<CR>

" Remap redo to Shift + U
nnoremap <silent> U <C-r>

" Keybinding for opening the file tree (NERDTree)
nnoremap <silent> t :NERDTreeToggle<CR>

" Keybinding for toggling comments (Adapting Comment.nvim logic to vim-commentary)
" 'c' to toggle comment on current line
nmap <silent> c gcc
" 'c' to toggle comment on visual selection
xmap <silent> c gc

" Keybinding for FZF (Telescope equivalent)
" Find in files (requires ripgrep/ag for Rg command, strictly speaking)
nnoremap <silent> <space>f :Rg<CR>
" Find files
nnoremap <silent> <space>g :Files<CR>
