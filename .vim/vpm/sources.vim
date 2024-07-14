" NERDTree
"it will be loaded on the first invocation of NERDTreeToggle command
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Lazy loading (on demand)
"Plug 'junegunn/goyo.vim', { 'for': 'markdown' }
"autocmd! User goyo.vim echom 'Goyo is now loaded!'

" Others
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'
Plug 'MarcWeber/vim-addon-commenting'
"Plug 'vim-scripts/vcscommand.vim'
"Plug 'vim-syntastic/syntastic'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets' " snippets collection
" Plug 'majutsushi/tagbar'
Plug 'liuchengxu/vista.vim'
Plug 'kien/ctrlp.vim'

" YouCompleteMe
function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !python3 install.py --java-completer
  endif
endfunction
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'davidhalter/jedi-vim'

" XML/HTML tags navigation
" Plug 'vim-scripts/matchit.zip'
Plug 'andymass/vim-matchup'

" Git/mercurial/others diff icons on the side of the file lines
Plug 'mhinz/vim-signify'
Plug 'zweifisch/pipe2eval'

" Vim-markdown
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'

" Color schemes
Plug 'crusoexia/vim-monokai'
" Plug 'rakr/vim-one'
" Plug 'ayu-theme/ayu-vim'
Plug 'arcticicestudio/nord-vim'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'tomasr/molokai'
Plug 'antonio-hickey/citrus-mist'

" Others
Plug 'vim-scripts/vis'
Plug 'roxma/vim-tmux-clipboard'
Plug 'lervag/vimtex'

" Fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'ferdinandyb/bibtexcite.vim'

" Vim-autoformat
Plug 'vim-autoformat/vim-autoformat'

Plug 'vimwiki/vimwiki'
Plug 'dyng/ctrlsf.vim'

" Unmanaged plugin (manually installed and updated)
"Plug '~/myplugin'
