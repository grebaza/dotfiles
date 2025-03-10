" -----------------------------
" Basic Settings & Leader
" -----------------------------
set nocompatible " Use Vim defaults rather than vi compatibility mode
let maplocalleader = ","

" -----------------------------
" Encryption & Editing Options
" -----------------------------
if has('patch-7.4.399')
  set cryptmethod=blowfish2
else
  set cryptmethod=blowfish
endif
set backspace=indent,eol,start
set autoindent
set wildmenu
set laststatus=2

" -----------------------------
" File Handling & Paths
" -----------------------------
set path+=**
if &modifiable
  set fileformat=unix
endif
" Combine wildignore patterns for performance
set wildignore=*.o,*~,*\.pyc,.git/*,.hg/*,.svn/*,*.DS_Store,CVS/*,*.mod

" -----------------------------
" Backup, Swap & Undo
" -----------------------------
set noswapfile
set undofile
set undodir=$HOME/.cache/vim/undo
if !isdirectory(&undodir)
  call mkdir(&undodir, 'p')
endif

" -----------------------------
" Behavior & Interface
" -----------------------------
set autochdir                     " Change directory to current file's directory
set hidden                        " Allow switching buffers without saving
set formatoptions+=ronl1j         " Adjust formatting options
" Define list patterns for auto-formatting lists
set formatlistpat=^\\s*[-*]\\s\\+
set formatlistpat+=\\\|^\\s*(\\(\\d\\+\\\|[a-z]\\))\\s\\+
set formatlistpat+=\\\|^\\s*\\(\\d\\+\\\|[a-z]\\)[:).]\\s\\+
set background=dark
" Remove GUI elements if running in a GUI
set guioptions-=m
set guioptions-=T
set guioptions-=L
set guioptions-=R

" -----------------------------
" Completion & Popup Menu
" -----------------------------
set complete+=U,s,k,kspell,]
set completeopt=menuone,noinsert,noselect
silent! set pumwidth=35

" -----------------------------
" Presentation & Layout
" -----------------------------
set matchtime=2
set matchpairs+=<:>
set scrolloff=2
set splitright
set previewheight=20
set noshowmode

" -----------------------------
" Indentation
" -----------------------------
set softtabstop=-1
set shiftwidth=2
set shiftround
set expandtab
set preserveindent
silent! set breakindent
set pastetoggle=<F10>

" -----------------------------
" Searching & Grep
" -----------------------------
set smartcase
set showmatch
set shortmess-=S
if executable('rg')
  set grepformat+=%f:%l:%c:%m
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif

" -----------------------------
" Appearance
" -----------------------------
set ruler
set number
set colorcolumn=80
set wrap
set linebreak
set showbreak=↪
syntax on
if has("statusline")
  set statusline=%<%t\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif

" -----------------------------
" Client-Server & Encoding
" -----------------------------
if empty(v:servername) && exists('*remote_startserver')
  call remote_startserver('VIM')
endif

if has("multi_byte")
  if &termencoding == ""
    let &termencoding = &encoding
  endif
  set encoding=utf-8
  setglobal fileencoding=utf-8
endif

" -----------------------------
" Ctags Management (PHP Example)
" -----------------------------
function! DelTagOfFile(file)
  let f = escape(substitute(a:file, getcwd() . "/", "", ""), './')
  let cmd = 'sed -i "/' . f . '/d" "' . getcwd() . '/tags"'
  call system(cmd)
endfunction

function! UpdateTags()
  let f = expand("%:p")
  let tagfile = getcwd() . "/tags"
  call DelTagOfFile(f)
  let cmd = 'ctags -a -f ' . tagfile . ' --c++-kinds=+p --fields=+iaS --extra=+q "' . f . '"'
  call system(cmd)
endfunction
augroup Ctags
  autocmd!
  autocmd BufWritePost *.php call UpdateTags()
augroup END

" -----------------------------
" GUI vs. Terminal
" -----------------------------
if has('gui_running')
  set guifont=DejaVu_Sans_Mono_for_Powerline:h9
else
  set mouse=a                    " Enable mouse support in terminal
endif

" -----------------------------
" Plugin Manager (Vim-Plug)
" -----------------------------
call plug#begin('~/.vim/plugged')
" Load additional plugin source list if used
source ~/.vim/vpm/sources.vim
call plug#end()

" =============================================================================
" Plugin-specific Configurations
" =============================================================================

" -----------------------------
" vim-airline Configuration
" -----------------------------
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#bufferline#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#vcs_priority = ["mercurial", "git"]
let g:airline_theme = 'dark'
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.space = "\ua0"
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" -----------------------------
" Tagbar & Vista (Outline Navigation)
" -----------------------------
" Tagbar settings (keeps tagbar window focused on current symbol)
let g:tagbar_autofocus = 1

" Vista configuration
nnoremap <F4> :Vista!!<CR>
let g:vista_stay_on_open = 0
let g:vista#renderer#enable_icon = 1
let g:vista#renderer#icons = {
      \ "function": "\uf794",
      \ "variable": "\uf71b",
      \ }

" -----------------------------
" NERDTree Settings
" -----------------------------
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
nmap <F3> :NERDTreeToggle<CR>
nmap <leader>nf :NERDTreeFind<CR>
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\.swp$', '.*\.swp$', '\.swo$', '\.swn$', '\.swh$', '\.swm$', '.*DS_Store']

" -----------------------------
" Custom Shortcuts
" -----------------------------
nnoremap <localleader>l :bnext<CR>
nnoremap <localleader>h :bprevious<CR>
nnoremap <localleader>d :b#<bar>bd#<CR>
nnoremap <leader>bl :ls<CR>
nnoremap <C-s> :up<CR>

" -----------------------------
" YouCompleteMe Settings
" -----------------------------
let g:ycm_add_preview_to_completeopt = 1
let ycm_trigger_key = '<C-n>'
let g:ycm_auto_trigger = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_key_invoke_completion = ycm_trigger_key
let g:ycm_key_list_select_completion = ['<Down>']
let g:ycm_key_list_previous_completion = ['<Up>']
let g:ycm_echo_current_diagnostic = 'virtual-text'
" Direct command mappings (non-recursive)
nnoremap <leader>yd :YcmCompleter GoToDefinition<CR>
nnoremap <leader>yt :YcmCompleter GetType<CR>
" Plug mappings require recursive mapping
nmap <leader>yfw <Plug>(YCMFindSymbolInWorkspace)
nmap <leader>yfd <Plug>(YCMFindSymbolInDocument)
nmap <leader>yh <Plug>(YCMHover)
" Expression mapping for triggering completion in insert mode
inoremap <expr> ycm_trigger_key pumvisible() ? "<Down>" : ycm_trigger_key

" -----------------------------
" UltiSnips Configuration
" -----------------------------
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" -----------------------------
" Syntastic Settings
" -----------------------------
nmap <leader>e :Errors<CR>
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '⚠'
let g:syntastic_style_error_symbol = '✗'
let g:syntastic_style_warning_symbol = '⚠'
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_mri_args = "--config=$HOME/.jshintrc"
let g:syntastic_python_checkers = ["pylint", "flake8", "python"]
let g:syntastic_python_flake8_args = "--ignore=E121,E123,E126,E133,E226,E241,E242,E704,W503,W504,W505,YCM112,YCM201,YCM202"
let g:syntastic_python_flake8_config_file = '.flake8'

" -----------------------------
" Jedi-vim Configuration
" -----------------------------
let g:jedi#completions_enabled = 0
let g:jedi#show_call_signatures = 0
let g:jedi#goto_command = '<localleader>jd'
let g:jedi#goto_assignments_command = '<localleader>ja'
let g:jedi#rename_command = "<localleader>jr"
let g:jedi#usages_command = '<localleader>ju'
nnoremap <localleader>jD :tab split<CR>:call jedi#goto()<CR>

" -----------------------------
" CtrlP Mappings
" -----------------------------
let g:ctrlp_working_path_mode = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules)$',
  \ 'file': '\.pyc$\|\.pyo$',
  \ }
" Launch CtrlP using <leader>p
let g:ctrlp_map = '<leader>p'

" Direct CtrlP commands (invoked immediately)
nnoremap <leader>pb :CtrlPBufTag<CR>
nnoremap <leader>pB :CtrlPBufTagAll<CR>
nnoremap <leader>pl :CtrlPLine<CR>
nnoremap <leader>pm :CtrlPMRUFiles<CR>

" Custom function for CtrlP with pre-filled search text
function! CtrlPWithSearchText(search_text, ctrlp_command_end)
  execute ':CtrlP' . a:ctrlp_command_end
  call feedkeys(a:search_text)
endfunction

" CtrlP commands with search text (using <leader>ps prefix)
nnoremap <leader>psb :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
nnoremap <leader>psB :call CtrlPWithSearchText(expand('<cword>'), 'BufTagAll')<CR>
nnoremap <leader>psl :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
nnoremap <leader>ps  :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
nnoremap <leader>psf :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>
nnoremap <leader>psm :call CtrlPWithSearchText(expand('<cword>'), 'MRUFiles')<CR>
nnoremap <leader>psc :call CtrlPWithSearchText(expand('<cword>'), 'CmdPalette')<CR>

" -----------------------------
" Vim-Markdown Settings
" -----------------------------
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_strikethrough = 1

" -------------------------
" Location List Shortcuts
" -------------------------
" Navigate location list entries:
nnoremap <leader>ln :lnext<CR>      " Next location entry
nnoremap <leader>lp :lprev<CR>      " Previous location entry
nnoremap <leader>lo :lopen<CR>      " Open the location list window
nnoremap <leader>ll :llist<CR>      " List all location list items

" ------------------
" fzf.vim Mappings
" ------------------
" Define fzf command prefix as 'Fzf' (used internally)
let g:fzf_command_prefix = 'Fzf'

" Launch fzf actions with mnemonic mappings under <leader>f:
nnoremap <silent> <leader>fc :FzfCommands<CR>
nnoremap <silent> <leader>ft :FzfTags<CR>
nnoremap <silent> <leader>fb :FzfBuffers<CR>
nnoremap <silent> <leader>fs :FzfSnippets<CR>
nnoremap <silent> <leader>ff :FzfFiles<CR>
nnoremap <silent> <leader>fB :FzfBTags<CR>

" -----------------------------
" Vim-Autoformat
" -----------------------------
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
let g:autoformat_on_save = 0

function! ToggleAutoformat()
  let g:autoformat_on_save = !g:autoformat_on_save
  echo "Autoformat on save " . (g:autoformat_on_save ? "enabled" : "disabled")
endfunction

nnoremap <F2> :Autoformat<CR>
nnoremap <C-F2> :call ToggleAutoformat()<CR>

augroup Autoformatting
  autocmd!
  autocmd BufWritePre * if g:autoformat_on_save | Autoformat | endif
augroup END

" -----------------------------
" Vimtex & BibTeX Integration
" -----------------------------
set conceallevel=2
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode = 0
let g:vimtex_compiler_latexmk = {
      \ 'callback': 1,
      \ 'continuous': 1,
      \ 'executable': 'latexmk',
      \ 'hooks': [],
      \ 'options': ['-verbose', '-file-line-error', '-synctex=1', '-interaction=nonstopmode'],
      \}
" Inkscape figures mappings (adjust as needed)
augroup VimtexInkscape
  autocmd!
  autocmd FileType tex inoremap <buffer> <C-f> <Esc>:silent exec '.!inkscape-figures create "' . getline('.') . '" "' . b:vimtex.root . '/figures/"'<CR><CR>:w<CR>
  autocmd FileType tex nnoremap <buffer> <C-f> :silent exec '!inkscape-figures edit "' . b:vimtex.root . '/figures/" > /dev/null 2>&1 &'<CR>:redraw!<CR>
augroup END

" -------------------------------------------------------
" BibtexCite Integration (works with go pkg fzf-bibtex)
" -------------------------------------------------------
function! s:bibfiles()
  let bibfiles = (
      \ globpath('.', '*.bib', v:true, v:true) +
      \ globpath('..', '*.bib', v:true, v:true) +
      \ globpath('*/', '*.bib', v:true, v:true)
      \ )
  let bibfiles = join(bibfiles, ' ')
  return bibfiles
endfunction

function! Bibtex_ls()
  let source_cmd = 'bibtex-ls '.s:bibfiles()
  return source_cmd
endfunction

function! s:bibtex_cite_mode()
    let arg=''
    if &filetype ==# 'tex'
      let arg='-mode=latex'
    endif
    return arg
endfunction

function! s:bibtex_cite_sink(lines)
    let r=system("bibtex-cite ". s:bibtex_cite_mode(), a:lines)
    execute ':normal! a' . r
endfunction

function! s:bibtex_markdown_sink(lines)
    let bibfiles=Bibtex_ls()
    let r=system("bibtex-markdown " . s:bibfiles(), a:lines)
    execute ':normal! a' . r
endfunction

function! s:bibtex_cite_sink_insert(lines)
    let r=system("bibtex-cite ". s:bibtex_cite_mode(), a:lines)
    execute ':normal! a' . r
    call feedkeys('a', 'n')
endfunction

nnoremap <silent> <leader>cc :call fzf#run({
                        \ 'source': Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>

nnoremap <silent> <leader>cm :call fzf#run({
                        \ 'source': Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_markdown_sink'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Markdown> "'})<CR>

inoremap <silent> @@ <c-g>u<c-o>:call fzf#run({
                        \ 'source': Bibtex_ls(),
                        \ 'sink*': function('<sid>bibtex_cite_sink_insert'),
                        \ 'up': '40%',
                        \ 'options': '--ansi --layout=reverse-list --multi --prompt "Cite> "'})<CR>

nnoremap <silent> <leader>cs :let g:bibtexcite_bibfile=<SID>bibfiles() \| :BibtexciteShowcite<CR>

" ----------------------------
" CtrlsF Mappings
" ----------------------------
" Normal Mode:
nnoremap <C-F>q <Plug>CtrlSFPrompt     " Launch CtrlSF prompt ("q" for query)
nnoremap <C-F>w <Plug>CtrlSFCwordPath  " Search current word (cword, "w" for word)
nnoremap <C-F>p <Plug>CtrlSFPwordPath  " Search partial word (pword, "p" for partial)
nnoremap <C-F>o :CtrlSFOpen<CR>        " Open CtrlSF results window ("o" for open)
nnoremap <C-F>t :CtrlSFToggle<CR>      " Toggle CtrlSF interface ("t" for toggle)

" Visual Mode:
vmap <C-F>s <Plug>CtrlSFVwordPath      " Use selection for search ("s" for selection)
vmap <C-F>S <Plug>CtrlSFVwordExec      " Search on selection (capital "S" for execute)

" Insert Mode:
inoremap <C-F>t <Esc>:CtrlSFToggle<CR> " Toggle CtrlSF interface in insert mode

" -----------------------------
" Vimwiki Settings
" -----------------------------
let g:vimwiki_list = [{'path': '~/wiki/', 'syntax': 'markdown', 'ext': 'md'}]
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown'}
let g:vimwiki_global_ext = 0
let g:vimwiki_markdown_link_ext = 1
let g:vimwiki_folding = ''
let g:vimwiki_key_mappings = {'table_mappings': 0}

" ------------------------------------
" Custom Markdown Conceal (GRE Prep)
" ------------------------------------
augroup CustomMarkdownConceal
  autocmd!
  autocmd FileType markdown,vimwiki syntax region customTag start=">-" end="-<" conceal cchar=•
augroup END

" Set high foldlevel to prevent unwanted folding on startup
set foldlevel=99

" ------------------------------------
"  Vim-Oscyank
" ------------------------------------
let g:oscyank_silent = 0
let g:oscyank_on_yank = 0

" Toggle OSC 52 sequence on yank
function! ToggleOscYank() abort
  let g:oscyank_on_yank = !g:oscyank_on_yank
  echo "OSC 52 Yank " . (g:oscyank_on_yank ? "enabled" : "disabled")
endfunction

" Auto-apply OSCYank to relevant registers after yank
let s:oscyank_registers = ['+', '*']
let s:oscyank_operators = ['y']

function! s:OscYankCallback(event) abort
  if index(s:oscyank_registers, a:event.regname) >= 0
        \ && index(s:oscyank_operators, a:event.operator) >= 0
    call OSCYankRegister(a:event.regname)
  endif
endfunction

" Toggle automatic OSCYank (oT: OSC Toggle)
nnoremap <leader>ot :call ToggleOscYank()<CR>
" Manually send current register via OSCYank (oS: OSC Send)
nnoremap <leader>os :call OSCYankRegister(v:register)<CR>

augroup VimOscYankAuto
  autocmd!
  autocmd TextYankPost * if g:oscyank_on_yank | call s:OscYankCallback(v:event) | endif
augroup END


" =============================================================================
" Final Appearance
" =============================================================================
if has('termguicolors') | set termguicolors | endif
colorscheme sonokai
highlight clear Conceal


" jdt.ls lombok support
let $JAVA_TOOL_OPTIONS = "-javaagent:/home/guillermo/.m2/repository/org/projectlombok/lombok/1.18.24/lombok-1.18.24.jar -Xbootclasspath/a:/home/guillermo/.m2/repository/org/projectlombok/lombok/1.18.24/lombok-1.18.24.jar"
