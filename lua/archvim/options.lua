vim.g.mapleader = ','

vim.cmd [[
set mouse=a
set mousemodel=extend
set updatetime=300
set nu nornu ru ls=2
set et sts=0 ts=4 sw=4
set signcolumn=number
set bri wrap
set nohls
set listchars=tab:▸\ ,trail:⋅,extends:❯,precedes:❮
set cinoptions=j1,(0,ws,Ws,g0,:0,=0,l1
set cinwords=if,else,switch,case,for,while,do
set showbreak=↪
set list
set clipboard+=unnamedplus
set switchbuf=useopen
set exrc
set foldtext='+--'
set wrap
]]

vim.cmd [[
augroup disable_formatoptions_cro
autocmd!
autocmd BufEnter * setlocal formatoptions-=cro
augroup end
]]

vim.cmd [[
augroup disable_swap_exists_warning
autocmd!
autocmd SwapExists * let v:swapchoice = "e"
augroup end
]]

-- vim.cmd [[
-- augroup neogit_setlocal
-- autocmd!
-- autocmd FileType NeogitStatus set foldtext='+--'
-- augroup END
-- ]]

vim.cmd [[
augroup quickfix_setlocal
autocmd!
autocmd FileType qf setlocal wrap
autocmd FileType qf vnoremap <buffer> <F6> <cmd>cclose<CR>
autocmd FileType qf nnoremap <buffer> <F6> <cmd>cclose<CR>
autocmd FileType qf vnoremap <buffer> <F18> <cmd>cclose<CR>
autocmd FileType qf nnoremap <buffer> <F18> <cmd>cclose<CR>
augroup END
]]

vim.cmd [[
augroup trouble_setlocal
autocmd!
autocmd FileType trouble setlocal wrap
augroup END
]]

vim.cmd [[
augroup trouble_setlocal
autocmd!
autocmd ColorScheme * hi Normal guibg=none
" | hi NormalFloat guifg=#928374 guibg=#282828
" | hi WinSeparator guibg=none
" | hi TreesitterContext gui=NONE guibg=#282828
" | hi TreesitterContextBottom gui=underline guisp=Grey
augroup END
]]

vim.cmd [[
set termguicolors
" colorscheme gruvbox
colorscheme zephyr
]]

-- vim.g_printed = ''
-- vim.g_print = function(msg)
--     vim.g_printed = vim.g_printed .. tostring(msg) .. '\n'
-- end
-- vim.g_dump = function()
--     print(vim.g_printed)
-- end

vim.lsp.set_log_level("off")
