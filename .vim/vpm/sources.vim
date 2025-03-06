" ==============================
" PLUGINS CONFIGURATION
" ==============================

" --- NERDTree (File Explorer) ---
Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'PhilRunninger/nerdtree-visual-selection'

" --- Version Control ---
Plug 'tpope/vim-fugitive'  " Git integration
Plug 'mhinz/vim-signify'   " Git/Mercurial diff markers

" --- Status Bar & UI Enhancements ---
Plug 'vim-airline/vim-airline' | Plug 'vim-airline/vim-airline-themes'

" --- Snippets ---
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets' " snippets collection

" --- Autocomplete (YouCompleteMe & Python Support) ---
function! BuildYCM(info)
  " info has 3 fields: name, status ('installed', 'updated', or 'unchanged'),
  " and force (set on PlugInstall! or PlugUpdate!)
  if a:info.status == 'installed' || a:info.force
    !python3 install.py --all --ninja
  endif
endfunction
Plug 'ycm-core/YouCompleteMe', { 'do': function('BuildYCM') }
Plug 'davidhalter/jedi-vim' " Python autocompletion

" --- Syntax & Code Navigation ---
Plug 'michaeljsmith/vim-indent-object' " Better indentation motions
Plug 'andymass/vim-matchup' " Enhanced % navigation for matching pairs

" --- Tag Navigation ---
Plug 'liuchengxu/vista.vim' " Tagbar alternative with LSP support

" --- File Search & Navigation ---
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy file search
Plug 'junegunn/fzf' | Plug 'junegunn/fzf.vim'

" --- Markdown & LaTeX Support ---
Plug 'godlygeek/tabular'
Plug 'preservim/vim-markdown'
Plug 'lervag/vimtex' " LaTeX editing & compiling
Plug 'ferdinandyb/bibtexcite.vim' " BibTeX citations

" --- Color Schemes ---
Plug 'crusoexia/vim-monokai'
Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
Plug 'tomasr/molokai'
Plug 'sainnhe/sonokai'

" --- Autoformatting & Commenting ---
Plug 'vim-autoformat/vim-autoformat'
Plug 'tpope/vim-commentary' " Easily comment/uncomment code
" Plug 'tpope/vim-surround' " Better text object manipulation
" Plug 'vim-scripts/vis'

" --- Miscellaneous ---
Plug 'ojroques/vim-oscyank'
Plug 'roxma/vim-tmux-clipboard' " Clipboard integration with tmux
Plug 'vimwiki/vimwiki' " Personal wiki in Vim
Plug 'dyng/ctrlsf.vim' " Full-text search
Plug 'pprovost/vim-ps1' " PowerShell syntax highlighting

" --- Manually Installed Plugins (Unmanaged) ---
" Plug '~/myplugin'
