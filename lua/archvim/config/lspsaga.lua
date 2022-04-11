-- https://github.com/tami5/lspsaga.nvim

require("lspsaga").setup {
    -- 提示边框样式：round、single、double
    border_style = "round",
    error_sign = " ",
    warn_sign = " ",
    hint_sign = " ",
    infor_sign = " ",
    diagnostic_header_icon = " ",
    -- 正在写入的行提示
    code_action_icon = " ",
    code_action_prompt = {
        -- 显示写入行提示
        -- 如果为 true ，则写代码时会在左侧行号栏中显示你所定义的图标
        enable = false,
        sign = true,
        sign_priority = 40,
        virtual_text = true,
    },
    -- 快捷键配置
    code_action_keys = {
        quit = "<Esc>",
        exec = "<CR>",
    },
    rename_action_keys = {
        quit = "<Esc>",
        exec = "<CR>",
    },
}

vim.cmd [[
" code action
nnoremap <silent> ga <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent> ga :<C-u>lua require('lspsaga.codeaction').range_code_action()<CR>

" rename, close rename win use <C-c> in insert mode or `q` in noremal mode or `:q`
nnoremap <silent> gr <cmd>lua require('lspsaga.rename').rename()<CR>

" preview definition
nnoremap <silent> gd <cmd>lua require('lspsaga.provider').preview_definition()<CR>

" show hover doc
nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
" scroll down hover doc or scroll in definition preview
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
" scroll up hover doc
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
" show signature help
nnoremap <silent> gs <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>

" show diagnostic on current line
nnoremap <silent> gl <cmd>lua require('lspsaga.diagnostic').show_line_diagnostics()<CR>
" only show diagnostic if cursor is over the area
nnoremap <silent> gL <cmd>lua require('lspsaga.diagnostic').show_cursor_diagnostics()<CR>

" jump diagnostic
nnoremap <silent> [g <cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev()<CR>
nnoremap <silent> ]g <cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>
]]