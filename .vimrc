let maplocalleader = ","

" Options
if has('patch-7.4.399')
  set cryptmethod=blowfish2
else
  set cryptmethod=blowfish
endif
set backspace=indent,eol,start
set wildmenu
set laststatus=2
set autoindent

" Basic
se nocompatible
set path+=**
if &modifiable
  set fileformat=unix
endif
set wildignore=*.o
set wildignore+=*~
set wildignore+=*.pyc
set wildignore+=.git/*
set wildignore+=.hg/*
set wildignore+=.svn/*
set wildignore+=*.DS_Store
set wildignore+=CVS/*
set wildignore+=*.mod

" Backup, swap and undofile
set noswapfile
set undofile
set undodir=$HOME/.cache/vim/undo
if !isdirectory(&undodir)
  call mkdir(&undodir, 'p')
endif

" Behaviour
set autochdir " always switch to the current file directory
set hidden
set formatoptions+=ronl1j
set formatlistpat=^\\s*[-*]\\s\\+
set formatlistpat+=\\\|^\\s*(\\(\\d\\+\\\|[a-z]\\))\\s\\+
set formatlistpat+=\\\|^\\s*\\(\\d\\+\\\|[a-z]\\)[:).]\\s\\+
set background=dark
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=L  "remove left-hand scroll bar
set guioptions-=R  "remove right-hand scroll bar

" Completion
set complete+=U,s,k,kspell,]
set completeopt=menuone
silent! set completeopt+=noinsert,noselect
silent! set pumwidth=35

" Presentation
set matchtime=2
set matchpairs+=<:>
set scrolloff=2
" set splitbelow
set splitright
set previewheight=20
set noshowmode

" Indentation
set softtabstop=-1
set shiftwidth=2
set shiftround
set expandtab
set preserveindent
silent! set breakindent
set pastetoggle=<F10>

" Searching
set smartcase
set showmatch
set shortmess-=S

if executable('rg')
  set grepformat+=%f:%l:%c:%m
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif

" Appearance
set ruler
" set t_Co=256
set number
set colorcolumn=80
syntax on
" silent! colorscheme torte
if has("statusline")
  set statusline=%<%t\ %h%m%r%=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}%k\ %-14.(%l,%c%V%)\ %P
endif
" highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" Automatically source vimrc on save {{{
" autocmd! bufwritepost $MYVIMRC source $MYVIMRC
" }}}
au BufNewFile,BufRead *.pck set filetype=sql


" Client-server feature {{{
" This will only work if `vim --version` includes `+clientserver`!
if empty(v:servername) && exists('*remote_startserver')
  call remote_startserver('VIM')
endif
" }}}

" jdtls lombok support
" let $JAVA_TOOL_OPTIONS = "-javaagent:/home/guillermo/.m2/repository/org/projectlombok/lombok/1.18.24/lombok-1.18.24.jar -Xbootclasspath/a:/home/guillermo/.m2/repository/org/projectlombok/lombok/1.18.24/lombok-1.18.24.jar"

" Preferred encoding {{{
  if has("multi_byte")
    if &termencoding == ""
      let &termencoding = &encoding
    endif
    set encoding=utf-8            " better default than latin1
    setglobal fileencoding=utf-8  " change default file encoding for new files
  endif
" }}}


" Ctags Management {{{
  function! DelTagOfFile(file)
    let fullpath = a:file
    let cwd = getcwd()
    let tagfilename = cwd . "/tags"
    let f = substitute(fullpath, cwd . "/", "", "")
    let f = escape(f, './')
    let cmd = 'sed -i "/' . f . '/d" "' . tagfilename . '"'
    let resp = system(cmd)
  endfunction

  function! UpdateTags()
    let f = expand("%:p")
    let cwd = getcwd()
    let tagfilename = cwd . "/tags"
    let cmd = 'ctags -a -f ' . tagfilename .
          \ ' --c++-kinds=+p --fields=+iaS --extra=+q ' . '"' . f . '"'
    call DelTagOfFile(f)
    let resp = system(cmd)
  endfunction
  autocmd BufWritePost *.php call UpdateTags()
" }}}


" Environments (GUI / Console) {{{
  if has('gui_running')
      set guifont=DejaVu_Sans_Mono_for_Powerline:h9
  else
      "mouse support
      set mouse=a
  endif
" }}}


" Vim-Plug {{{
  call plug#begin('~/.vim/plugged')

  source ~/.vim/vpm/sources.vim

  call plug#end()
" }}}


" vim-airline {{{
  "extensions integration
  "enable/disable enhanced tabline
  let g:airline#extensions#tabline#enabled = 1
  let g:airline#extensions#tabline#fnamemod = ':t'
  let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
  "enable/disable displaying buffers with a single tab
  let g:airline#extensions#tabline#show_buffers = 1
  let g:airline#extensions#tabline#formatter = 'unique_tail'
  " let g:airline#extensions#tabline#show_tabs = 0
  "configure how numbers are displayed in tab mode
  " let g:airline#extensions#tabline#tab_nr_type = 1
  " let g:airline#extensions#tabline#buffers_label = 'b'
  " let g:airline#extensions#tabline#tabs_label = 't'
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''

  let g:airline#extensions#bufferline#enabled = 1
  let g:airline#extensions#syntastic#enabled = 1
  let g:airline#extensions#tagbar#enabled = 1
  let g:airline#extensions#branch#enabled = 1
  " let g:airline#extensions#branch#use_vcscommand = 1
  let g:airline#extensions#branch#vcs_priority = ["mercurial", "git"]
  "theming
  let g:airline_theme = 'dark'
  let g:airline_powerline_fonts = 1
  if !exists('g:airline_symbols')
    let g:airline_symbols = {}
  endif
  " powerline symbols
  let g:airline_symbols.space = "\ua0"
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
" }}}


" Tagbar {{{
  " map <F4> :TagbarToggle<CR>
  " autofocus on tagbar open
  let g:tagbar_autofocus = 1
  " yaml support
  let g:tagbar_type_yaml = {
      \ 'ctagstype' : 'yaml',
      \ 'kinds' : [
          \ 'a:anchors',
          \ 's:section',
          \ 'e:entry'
      \ ],
      \ 'sro' : '.',
      \ 'scope2kind': {
        \ 'section': 's',
        \ 'entry': 'e'
      \ },
      \ 'kind2scope': {
        \ 's': 'section',
        \ 'e': 'entry'
      \ },
      \ 'sort' : 0
      \ }
" }}}

" Vista {{{
  map <F4> :Vista!!<CR>
  let g:vista_stay_on_open = 0
  let g:vista#renderer#enable_icon = 1
  let g:vista#renderer#icons = {
        \   "function": "\uf794",
        \   "variable": "\uf71b",
        \  }
  map <localleader>t :FzfBTags<CR>
" }}}


" NERDTree {{{
  let g:NERDTreeDirArrowExpandable = '▸'
  let g:NERDTreeDirArrowCollapsible = '▾'
  map <F3> :NERDTreeToggle<CR>
  " open nerdtree with the current file selected
  nmap ,r :NERDTreeFind<CR>
  " don;t show these file types
  let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\.swp', '*\.swp', '\.swo',
        \'\.swn', '\.swh', '\.swm', '.DS_Store']
" }}}


" My shortcuts {{{
  nmap <leader>l :bnext<CR>
  nmap <leader>h :bprevious<CR>
  nmap <leader>d :bp <BAR> bd #<CR>
  nmap <leader>bl :ls<CR>
  nmap <c-s> :up<CR>
  " noremap <silent> <C-S> :update<CR>
  " vnoremap <silent> <C-S> <C-C>:update<CR>
  " inoremap <silent> <C-S> <C-O>:update<CR>
" }}}


" VCS-Command {{{
  let VCSCommandVCSTypePreference = 'hg git svn'
" }}}


" YouCompleteMe {{{
  let g:ycm_add_preview_to_completeopt = 1
  let ycm_trigger_key = '<C-n>'
  let g:ycm_auto_trigger = 1
  let g:ycm_autoclose_preview_window_after_completion = 1
  let g:ycm_autoclose_preview_window_after_insertion = 1
  let g:ycm_key_invoke_completion = ycm_trigger_key
  " this is some arcane magic to allow cycling through the YCM options
  " with the same key that opened it.
  " See http://vim.wikia.com/wiki/Improve_completion_popup_menu for more info.
  let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
  let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
  let g:ycm_echo_current_diagnostic = 'virtual-text'
  " let g:ycm_enable_inlay_hints = 1
  nmap <leader>yfw <Plug>(YCMFindSymbolInWorkspace)
  nmap <leader>yfd <Plug>(YCMFindSymbolInDocument)
  nnoremap <leader>yd :YcmCompleter GoToDefinition<CR>
  nnoremap <leader>yt :YcmCompleter GetType<CR>
  inoremap <expr> ycm_trigger_key pumvisible() ? "<Down>" : ycm_trigger_key;
  nmap <leader>D <plug>(YCMHover)
" }}}


" UltiSnip {{{
 let g:UltiSnipsExpandTrigger="<tab>"
 let g:UltiSnipsJumpForwardTrigger = "<tab>"
 let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" }}}


" Syntastic {{{
  " show list of errors and warnings on the current file
  nmap <leader>e :Errors<CR>
  " check also when just opened the file
  " let g:syntastic_check_on_open = 1
  " don't put icons on the sign column
  " let g:syntastic_enable_signs = 0
  " custom icons (enable them if you use a patched font, and enable signs
  let g:syntastic_error_symbol = '✗'
  let g:syntastic_warning_symbol = '⚠'
  let g:syntastic_style_error_symbol = '✗'
  let g:syntastic_style_warning_symbol = '⚠'
  let g:syntastic_javascript_checkers = ['eslint']
  let g:syntastic_javascript_mri_args = "--config=$HOME/.jshintrc"
  let g:syntastic_python_checkers=["pylint", "flake8", "python"]
  let g:syntastic_python_flake8_args="--ignore=E121,E123,E126,E133,E226,
        \E241,E242,E704,W503,W504,W505,YCM112,YCM201,YCM202"
  let g:syntastic_python_flake8_config_file='.flake8'
" }}}


" Jedi-vim {{{
  " avoid conflict with YCM
  let g:jedi#completions_enabled = 0
  " Go to definition
  let g:jedi#goto_command = ',d'
  " Find ocurrences
  let g:jedi#usages_command = ',o'
  " Find assignments
  let g:jedi#goto_assignments_command = ',a'
  " Go to definition in new tab
  nmap ,D :tab split<CR>:call jedi#goto()<CR>
" }}}


" CtrlP {{{
  " don't change working directory
  let g:ctrlp_working_path_mode = 0
  " ignore these files and folders on file finder
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/](\.git|\.hg|\.svn|node_modules)$',
    \ 'file': '\.pyc$\|\.pyo$',
    \ }
  " file finder mapping
  let g:ctrlp_map = ',e'
  " nnoremap ; :CtrlPBuffer<CR>
  " tags (symbols) in current file finder mapping
  nmap ,g :CtrlPBufTag<CR>
  " tags (symbols) in all files finder mapping
  nmap ,G :CtrlPBufTagAll<CR>
  " general code finder in all files mapping
  nmap ,f :CtrlPLine<CR>
  " recent files finder mapping
  nmap ,m :CtrlPMRUFiles<CR>
  " to be able to call CtrlP with default search text
  function! CtrlPWithSearchText(search_text, ctrlp_command_end)
      execute ':CtrlP' . a:ctrlp_command_end
      call feedkeys(a:search_text)
  endfunction
  " same as previous mappings, but calling with current word as default text
  nmap ,wg :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
  nmap ,wG :call CtrlPWithSearchText(expand('<cword>'), 'BufTagAll')<CR>
  nmap ,wf :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
  nmap ,we :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
  nmap ,pe :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>
  nmap ,wm :call CtrlPWithSearchText(expand('<cword>'), 'MRUFiles')<CR>
  nmap ,wc :call CtrlPWithSearchText(expand('<cword>'), 'CmdPalette')<CR>
" }}}

" vim-markdown {{{
  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_math = 1
  let g:vim_markdown_frontmatter = 1
  let g:vim_markdown_toml_frontmatter = 1
  let g:vim_markdown_strikethrough = 1
" }}}

" Location List (loclist) {{{
  " loclist locations
  nmap <leader>sn :lnext<CR>
  nmap <leader>sp :lprev<CR>
  nmap <leader>se :lopen<CR>
  nmap <leader>sl :llist<CR>
" }}}

" vim-addon-commenting {{{
let g:vim_addon_commenting = {'force_filetype_comments': {'java': ['//','']}}
" }}}

" fzf.vim {{{
let g:fzf_command_prefix = 'Fzf'
nnoremap <silent> <leader>;  :FzfCommands<CR>
nnoremap <silent> <leader>t  :FzfTags<CR>
nmap <localleader>b :FzfBuffers<CR>
nmap <localleader>s :FzfSnippets<CR>
nmap 'f :FzfFiles<CR>
" }}}

" vim-autoformat {{{
noremap <F2> :Autoformat<CR>
au BufWrite * :Autoformat
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
" autocmd FileType vim,tex let b:autoformat_autoindent=0
" }}}

" Vimtex {{{
set conceallevel=2
let g:vimtex_view_method = 'zathura'
let g:vimtex_quickfix_mode=0
let g:vimtex_compiler_latexmk = {
      \ 'callback' : 1,
      \ 'continuous' : 1,
      \ 'executable' : 'latexmk',
      \ 'hooks' : [],
      \ 'options' : [
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}
" inkscape-figures ext program
autocmd FileType tex inoremap <buffer> <C-f> <Esc>: silent exec '.!inkscape-figures create "'.getline('.').'" "'.b:vimtex.root.'/figures/"'<CR><CR>:w<CR>
autocmd FileType tex nnoremap <buffer> <C-f> : silent exec '!inkscape-figures edit "'.b:vimtex.root.'/figures/" > /dev/null 2>&1 &'<CR><CR>:redraw!<CR>
" fzf-bibtex integration
" let $FZF_BIBTEX_CACHEDIR = 'PATH-TO-CACHE-DIR'
" let $FZF_BIBTEX_SOURCES = 'PATH-TO-BIBTEX-FILE'

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

" bibtex-cite
" let g:bibtexcite_bibfile = ['/home/guillermo/control-thesis/dissertation/thesis/bibliography.bib']
" }}}

" CtrlsF {{{
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>
" }}}

" Vimwiki {{{
  let g:vimwiki_list = [{'path': '~/wiki/', 'syntax': 'markdown', 'ext': 'md'}]
  let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown'}
  let g:vimwiki_global_ext = 0
  let g:vimwiki_markdown_link_ext = 1
  let g:vimwiki_folding = ''
  let g:vimwiki_key_mappings = {'table_mappings': 0, }
"   augroup Mkd
"     au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn} setlocal syntax=markdown
"     au BufRead,BufWinEnter,BufNewFile *.{md,mdx,mdown,mkd,mkdn,markdown,mdwn}.{des3,des,bf,bfa,aes,idea,cast,rc2,rc4,rc5,desx} setlocal syntax=markdown
"   augroup END
" }}}

" Conceal text between Custom Tags
augroup CustomMarkdownConceal
  autocmd!
  au FileType markdown,vimwiki syntax region customTag start=">-" end="-<" conceal cchar=•
augroup END

set foldlevel=99
" autocmd VimEnter * MatchDebug

" After Vim-Plug
colorscheme molokai

highlight clear Conceal
