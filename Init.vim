" show line number
set number

" show leader key
set showcmd

let maplocalleader = "\<Space>"
" the default is , you can also set it to <Space> if you don’t like my setting

" remap c-w to avoid conflicts
:nnoremap <LocalLeader>w <C-w>

" load the vim.plug management system
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
      \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    endif

" install plugin
call plug#begin('~/.local/share/nvim/plugged')
Plug 'jalvesaq/Nvim-R' " swissknife for vim and R communication
Plug 'Shougo/unite.vim' " for citation using citation.vim
Plug 'rafaqz/citation.vim' " for citation used anywhere in md or rmd files
" snippet framework beginning
Plug 'ncm2/ncm2'  " snippet engine
Plug 'roxma/nvim-yarp' " dependency
Plug 'gaalcaras/ncm-R' " snippets
Plug 'ncm2/ncm2-ultisnips' " ncm and ultisnips integration
Plug 'SirVer/ultisnips'  " snippet engine
" snippets framework end
Plug 'chrisbra/csv.vim' "for viewing data directly in vim R (Nvim-R)
Plug 'junegunn/goyo.vim' "for nice zoom effet when editing, see screenshot below
Plug 'ferrine/md-img-paste.vim' "paste directly image in system clipboard to rmarkdown by putting images in an /img folder (created automatically)
call plug#end()

" set default R: radian
let R_app = "radian"
let R_cmd = "R"
let R_hl_term = 0
let R_args = []  " if you had set any
let R_bracketed_paste = 1

" enable buffer for all sessions
autocmd BufEnter * call ncm2#enable_for_buffer()

" IMPORTANT: :help Ncm2PopupOpen for more information
set completeopt=noinsert,menuone,noselect

" When the <Enter> key is pressed while the popup menu is visible, it only
" hides the menu. Use this mapping to close the menu and also start a new
" line.
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>") 

" Use <TAB> to select the popup menu:
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"""-----------""" Filetype
filetype plugin indent on

" set rmarkdown file type for safety

au BufNewFile,BufRead *.Rmd set filetype=rmd

"""-----------"""     Ability to paste directly image in system clipboard to rmarkdown by putting images in an /img folder (created automatically)

" here i'm using leader+p to paste image to markdown and rmarkdown
autocmd FileType markdown nmap p :call mdip#MarkdownClipboardImage()
autocmd FileType rmd nmap p :call mdip#MarkdownClipboardImage()

"""-----------"""     tricks

" make R starts automatically when .R or .Rmd file open and only starts one time
autocmd FileType r if string(g:SendCmdToR) == "function('SendCmdToR_fake')" | call StartR("R") | endif
autocmd FileType rmd if string(g:SendCmdToR) == "function('SendCmdToR_fake')" | call StartR("R") | endif
" make R vertical split at start
let R_rconsole_width = 57
let R_min_editor_width = 18
" some nice keybindding, D = cursor down one line when finished the code
" localleader+rv = view data, +rg = plot(graphic), +rs = summary, all without sending lines to R buffer, very useful
" Other useful features like Rformat and R RBuildTags aren’t covered here, see Nvim-R for more info.
" map ctrl a (all screen) to goyo to have a fullscreen R editing and Rmarkdown writing experience
nmap <LocalLeader>sc <Plug>RDSendChunk " useful when in Rmarkdown, send chunk 
nmap <LocalLeader>ss <Plug>RDSendLine " directly send line to R buffer when nothing selected
vmap <LocalLeader>ss <Plug>REDSendSelection " send selection in visual mode
nmap <LocalLeader>st <Plug>RDSendLineAndInsertOutput
nmap <LocalLeader>rc <Plug>RClearConsole " idem  
nmap <LocalLeader>rr <Plug>RStart  " rr is easier than rf  
vmap <LocalLeader>rr <Plug>RStart " idem  
nmap <LocalLeader>rq <Plug>RClose " rq = rquit, easier to remember  
vmap <LocalLeader>rq <Plug>RClose " idem
