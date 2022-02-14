let hostname = system('hostname')
let isFacebookMode = match(hostname, 'facebook') >= 0

set tabstop=4
set shiftwidth=4
let cMakePath="~denplusplus/work/arcadia/cmake/scripts/cMake.py"
if filereadable(cMakePath)
    set makeprg=cMakePath
else
    let cItPath="../cIt.sh"
    if filereadable(cItPath)
        execute "set makeprg=".cItPath
    endif
endif

if isFacebookMode
    set tabstop=2
    set shiftwidth=2
    set softtabstop=2
    source $LOCAL_ADMIN_SCRIPTS/master.vimrc
    source /home/engshare/admin/scripts/vim/biggrep.vim
    set makeprg=export\ PT=\$(realpath)\;\ cd\ ~/fbsource/fbcode;\ buck\ build\ --report-absolute-paths\ \$\{PT:40\}/...
endif

"set autoindent
set expandtab
syntax enable
set nocompatible
set backspace=2
set autowrite
set ruler
set nowrap
set incsearch
set hlsearch
set smartindent
set showcmd
set showmode

set viminfo='10,\"100,:20,%,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

source ~/.vim/NERD_commenter.vim
if !has("win32")
    source ~/.vim/taglist.vim
endif
source ~/.vim/a.vim
"source ~/.vim/word_complete.vim

let Tlist_GainFocus_On_ToggleOpen = 1
nnoremap <silent> <F8> :TlistToggle<CR>

nnoremap <silent> <F2> :w<CR>
nnoremap <silent> <F3> :Texplore<CR>
nnoremap <silent> <F4> :qa<CR>
nnoremap <silent> <F5> :Project<CR>
nnoremap <silent> <F6> :tabp<CR>
nnoremap <silent> <F7> :tabn<CR>
map <F9> :make release<CR>
map <C-F9> :make<CR>
map <Esc>b <C-Left>
map <Esc>f <C-Right>

set tags=/home/denplusplus/work/arcadia/tags,./tags,../tags,../../tags,../../../tags,../../../../tags
set path+=.,..,../..,../../..,../../../..

if has("gui_running")
    set guifont=Consolas
    set guioptions-=T
    if has("win32")
        lang en
    endif
    source ~/.vim/wombat.vim
endif

let b:encindex=0
function! RotateEnc()
        let y = -1
        while y == -1
                let encstring = "#8bit-cp1251#8bit-cp866#utf-8#koi8-r#"
                let x = match(encstring,"#",b:encindex)
                let y = match(encstring,"#",x+1)
                let b:encindex = x+1
                if y == -1
                        let b:encindex = 0
                else
                        let str = strpart(encstring,x+1,y-x-1)
                        return ":set encoding=".str
                endif
        endwhile
endfunction
set enc=utf-8

set list listchars=tab:>-,trail:~

set statusline=%<%f%h%m%r%=%b\ %{&encoding}\ 0x%B\ \ %l,%c%V\ %P
set laststatus=2

map gf :tabe <cfile><CR>

func! SwitchHeader()
    if bufname("%")=~'\.cpp'
        fin %:r.h
    else
        fin %:r.cpp
    endif
endfunc

nmap  :call SwitchHeader()<Enter>
autocmd FileType c,cpp,h autocmd BufWritePre <buffer> :%s/\s\+$//e

set t_Co=256

set wildmenu
set wildmode=list:longest
set completeopt=preview,menuone,longest

let g:solarized_termcolors=256
colorscheme solarized
set background=dark

if filereadable("/usr/local/share/clang/clang-format.py")
    map <C-I> :py3file /usr/local/share/clang/clang-format.py<cr>
else
    if filereadable("/usr/share/vim/addons/syntax/clang-format.py")
        map <C-I> :py3file /usr/share/vim/addons/syntax/clang-format.py<cr>
    else
        if filereadable("/usr/share/vim/vimfiles/syntax/clang-format.py")
            map <C-I> :py3file /usr/share/vim/vimfiles/syntax/clang-format.py<cr>
        else
            source ~/.vim/vim-clang-format/autoload/clang_format.vim
            source ~/.vim/vim-clang-format/plugin/clang_format.vim
            nmap <C-I> :ClangFormat<cr>
        endif
    endif
endif

if isFacebookMode
  " let g:fbvim_py_path_override='/home/denplusplus/scripts/vim/fbvimpylib/fbvim.py'
  " source /home/denplusplus/scripts/vim/fbvim.vim
  nmap <F5> :FBGW<CR>
endif

if $VIM_CRONTAB == "true"
  set nobackup
  set nowritebackup
endif

set runtimepath^=~/.vim/bundle/ctrlp.vim

augroup filetypedetect
    au BufRead,BufNewFile */BUCK setfiletype python
augroup END
