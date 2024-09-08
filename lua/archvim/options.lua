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
\ | vnoremap <buffer> <F6> <cmd>cclose<CR>
\ | nnoremap <buffer> <F6> <cmd>cclose<CR>
\ | vnoremap <buffer> <F18> <cmd>cclose<CR>
\ | nnoremap <buffer> <F18> <cmd>cclose<CR>
augroup END
]]

vim.cmd [[
augroup trouble_setlocal
autocmd!
autocmd FileType trouble setlocal wrap
augroup END
]]

vim.cmd [[
augroup neogit_setlocal
autocmd!
autocmd FileType NeogitStatus nnoremap <buffer> <F10> <cmd>:q<CR>
augroup END
]]

-- vim.api.nvim_set_hl(0, 'LspReferenceRead', {link = 'Search'})
-- vim.api.nvim_set_hl(0, 'LspReferenceText', {link = 'Search'})
-- vim.api.nvim_set_hl(0, 'LspReferenceWrite', {link = 'Search'})

local function setup_lsp(event)
    local id = vim.tbl_get(event, 'data', 'client_id')
    local client = id and vim.lsp.get_client_by_id(id)
    if client == nil then
        return
    end

    if client.server_capabilities.inlayHintProvider then
        if vim.lsp.inlay_hint ~= nil then
            vim.lsp.inlay_hint.enable(true)
        end
    end

    if client.supports_method('textDocument/documentHighlight') then
        local group = vim.api.nvim_create_augroup('highlight_symbol', {clear = false})

        vim.api.nvim_clear_autocmds({buffer = event.buf, group = group})

        vim.api.nvim_create_autocmd({'CursorHold', 'CursorHoldI'}, {
            group = group,
            buffer = event.buf,
            -- callback = vim.lsp.buf.document_highlight,
            callback = function()
                vim.cmd [[
            hi LspReferenceText guibg=none "gui=bold "guisp=#a3e697
            hi LspReferenceRead guibg=none "gui=bold "guisp=#87c2e6
            hi LspReferenceWrite guibg=none "gui=bold "guisp=#e8a475
]]
                vim.lsp.buf.document_highlight()
            end,
        })

        vim.api.nvim_create_autocmd({'CursorMoved', 'CursorMovedI'}, {
            group = group,
            buffer = event.buf,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'Setup LSP',
  callback = setup_lsp,
})

vim.api.nvim_create_user_command("LspInlayHintToggle", function ()
    if vim.lsp.inlay_hint.is_enabled() then
        vim.lsp.inlay_hint.enable(false)
    else
        vim.lsp.inlay_hint.enable(true)
    end
end, {desc = 'Toggle inlay hints'})

vim.api.nvim_create_user_command("LspDiagnosticsToggle", function ()
    if vim.diagnostic.is_enabled() then
        vim.diagnostic.enable(false)
    else
        vim.diagnostic.enable(true)
    end
end, {desc = 'Toggle diagnostics'})

vim.cmd [[
augroup colorscheme_mock
autocmd!
autocmd ColorScheme * hi Normal guibg=none | hi def link LspInlayHint Comment
    " \ | hi LspReferenceText guibg=none
    " \ | hi LspReferenceRead guibg=none
    " \ | hi LspReferenceWrite guibg=none
" hi NormalFloat guifg=#928374 guibg=#282828 |
" hi WinSeparator guibg=none |
" hi TreesitterContext gui=NONE guibg=#282828 |
" hi TreesitterContextBottom gui=underline guisp=Grey
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
