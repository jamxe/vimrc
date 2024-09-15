vim.api.nvim_create_user_command("Quit", function ()
    vim.cmd [[ wall | if &buftype == 'quickfix' | cclose | elseif &buftype == 'prompt' | quit! | else | quit | endif ]]
end, {desc = 'Quit current window'})
-- 讨厌 q 用作退出的“宏孝子”请删除这 3 行：
vim.keymap.set("n", "q", "<cmd>Quit<CR>", { silent = true })
vim.keymap.set("v", "q", "<Esc>", { silent = true })
vim.keymap.set("n", "Q", "q", { silent = true, noremap = true })

-- 讨厌 jk 的同学请删除这 4 行：
vim.keymap.set("i", "jk", "<Esc>", { silent = true })
vim.keymap.set("i", "kj", "<Esc>", { silent = true })
vim.keymap.set("t", "jk", "<C-\\><C-n>", { silent = true })
vim.keymap.set("t", "kj", "<C-\\><C-n>", { silent = true })

-- Functional wrapper for mapping custom keybindings
-- local function map(mode, lhs, rhs, opts)
--     if type(mode) == 'table' then
--         for i = 1, #mode do
--             map(mode[i], lhs, rhs, opts)
--         end
--         return
--     end
--     local options = { noremap = true }
--     if opts then
--         options = vim.tbl_extend("force", options, opts)
--     end
--     vim.api.nvim_set_keymap(mode, lhs, rhs, options)
-- end

local function is_quickfix_open()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(win)].buftype == 'quickfix' then
      return true
    end
  end
  return false
end

local function get_current_quickfix_entry()
  local qflist = vim.fn.getqflist({ idx = 0 })
  local current_idx = qflist.idx
  local entry = vim.fn.getqflist({ id = qflist.id, items = 0 }).items[current_idx]
  return entry
end

vim.keymap.set({"v", "n"}, "_", "+", { noremap = true })
vim.keymap.set({"v", "n"}, "gh", "(v:count == 0 || v:count == 1 ? '^^' : '^^' . (v:count - 1) . 'l')", { silent = true, expr = true })
vim.keymap.set({"v", "n"}, "gl", "(v:count == 0 || v:count == 1 ? '^$' : '^$' . (v:count - 1) . 'h')", { silent = true, expr = true })
vim.keymap.set({"v", "n"}, "gm", "gM", { noremap = true })
vim.keymap.set({"v", "n"}, "gM", "gm", { noremap = true })
vim.keymap.set({"v", "n", "i"}, "<F4>", "<cmd>wa<CR>")
vim.keymap.set({"v", "n", "i"}, "<F6>", function ()
    if is_quickfix_open() then
        if get_current_quickfix_entry() then
            return "<cmd>cn<CR>"
        else
            return "<cmd>cc<CR>"
        end
    else
        return "<cmd>cc<CR>"
    end
end, { noremap = true, expr = true })
vim.keymap.set({"v", "n", "i"}, "<F18>", function ()
    if is_quickfix_open() then
        if get_current_quickfix_entry() then
            return "<cmd>cp<CR>"
        else
            return "<cmd>cc<CR>"
        end
    else
        return "<cmd>cc<CR>"
    end
end, { noremap = true, expr = true })
vim.keymap.set({"v", "n", "i", "t"}, "<F7>", "<cmd>NvimTreeFindFileToggle<CR>", { silent = true })
vim.keymap.set({"v", "n", "i", "t"}, "<F9>", "<cmd>Trouble diagnostics toggle focus=false<CR>", { silent = true })
vim.keymap.set({"v", "n", "i", "t"}, "<F21>", "<cmd>Trouble diagnostics toggle focus=false filter.buf=0<CR>", { silent = true })
if pcall(require, "cmake-tools") then
    vim.keymap.set({"v", "n", "i", "t"}, "<F5>", "<cmd>wa<CR><cmd>if luaeval('require\"cmake-tools\".is_cmake_project()')|call execute('CMakeRun')|else|call execute('TermExec cmd=./run.sh')|endif<CR>", { silent = true })
    vim.keymap.set({"v", "n", "i", "t"}, "<F17>", "<cmd>wa<CR><cmd>if luaeval('require\"cmake-tools\".is_cmake_project()')|call execute('CMakeStopRunner')|call execute('CMakeStopExecutor')|else|call execute('TermExec cmd=\\<C-c>')|endif<CR>", { silent = true })
else
    vim.keymap.set({"v", "n", "i", "t"}, "<F5>", "<cmd>wa<CR><cmd>call execute('TermExec cmd=./run.sh')<CR>", { silent = true })
    vim.keymap.set({"v", "n", "i", "t"}, "<F17>", "<cmd>wa<CR><cmd>call execute('TermExec cmd=\\<C-c>')<CR>", { silent = true })
end
-- vim.keymap.set({"v", "n", "i", "t"}, "<F10>", "<cmd>Neogit<CR><cmd>set foldtext='+'<CR>", { silent = true })
vim.keymap.set({"v", "n", "i", "t"}, "<F10>", function()
    require'neogit'.open{}
end, { silent = true })
-- vim.keymap.set({"v", "n", "i", "t"}, "<F12>", "<cmd>NoiceAll<CR>", { silent = true })
-- vim.keymap.set({"v", "n", "i", "t"}, "<F10>", "<cmd>DapToggleBreakpoint<CR>", { silent = true })
-- vim.keymap.set({"v", "n", "i", "t"}, "<F22>", "<cmd>DapToggleRepl<CR>", { silent = true })
-- vim.keymap.set({"v", "n", "i", "t"}, "<F12>", "<cmd>DapStepOver<CR>", { silent = true })
-- vim.keymap.set({"v", "n", "i", "t"}, "<F24>", "<cmd>DapStepInto<CR>", { silent = true })
-- vim.keymap.set({"v", "n", "i", "t"}, "<C-F12>", "<cmd>DapStepOut<CR>", { silent = true })
-- if found_cmake then
--     vim.keymap.set({"v", "n", "i", "t"}, "<F9>", "<cmd>if luaeval('require\"cmake-tools\".is_cmake_project() and require\"dap\".session()==nil')|call execute('CMakeDebug')|else|call execute('DapContinue')|endif<CR>", { silent = true })
--     vim.keymap.set({"v", "n", "i", "t"}, "<F21>", "<cmd>if luaeval('require\"cmake-tools\".is_cmake_project() and require\"dap\".session()==nil')|call execute('CMakeStop')|else|call execute('DapTerminate')|endif<CR>", { silent = true })
-- else
--     vim.keymap.set({"v", "n", "i", "t"}, "<F9>", "<cmd>DapContinue<CR>", { silent = true })
--     vim.keymap.set({"v", "n", "i", "t"}, "<F21>", "<cmd>DapTerminate<CR>", { silent = true })
-- end
vim.keymap.set({'v', 'n', 'i', 't'}, '<Ins>', [[<Cmd>ZenMode<CR>]])
-- vim.keymap.set({"v", "n"}, "<CR>", "<cmd>nohlsearch<CR>", { silent = true })

vim.keymap.set({"v", "n"}, "g=", "<cmd>Neoformat<CR>", { silent = true })
vim.keymap.set({"v", "n"}, "go", "<cmd>Ouroboros<CR>", { silent = true })
vim.keymap.set({"v", "n"}, "gO", "<cmd>split | Ouroboros<CR>", { silent = true })
vim.keymap.set({"v", "n"}, "g<C-o>", "<cmd>vsplit | Ouroboros<CR>", { silent = true })
-- vim.keymap.set({"v", "n", "i"}, "<F10>", "<cmd>Neoformat<CR>", { silent = true })
-- vim.keymap.set("n", "Q", "<cmd>wa<CR><cmd>qa!<CR>", { silent = true })

-- vim.cmd [[
-- command! -nargs=0 A :ClangdSwitchSourceHeader
-- command! -nargs=? F :Neoformat <f-args>
-- ]]

-- vim.api.nvim_create_autocmd({"VimEnter"}, {
--     -- disable_n_more_files_to_edit
--     callback = function (data)
--         local no_name = data.file == "" and vim.bo[data.buf].buftype == ""
--         if not no_name then
--             -- vim.cmd [[ args % ]]
--         end
--     end,
-- })

vim.keymap.set({'v', 'n', 'i', 't'}, '<C-h>', [[<Cmd>wincmd h<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<C-j>', [[<Cmd>wincmd j<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<C-k>', [[<Cmd>wincmd k<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<C-l>', [[<Cmd>wincmd l<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-h>', [[<Cmd>wincmd H<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-j>', [[<Cmd>wincmd J<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-k>', [[<Cmd>wincmd K<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-l>', [[<Cmd>wincmd L<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-w>', [[<Cmd>wincmd w<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-r>', [[<Cmd>wincmd r<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-x>', [[<Cmd>wincmd x<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-s>', [[<Cmd>wincmd s<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-v>', [[<Cmd>wincmd v<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-=>', [[<Cmd>wincmd +<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-->', [[<Cmd>wincmd -<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-,>', [[<Cmd>wincmd <Lt><CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-.>', [[<Cmd>wincmd ><CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<C-q>', [[<Cmd>wincmd q<CR>]])
vim.keymap.set({'v', 'n', 'i', 't'}, '<M-q>', [[<Cmd>wincmd q<CR>]])
vim.keymap.set('n', '<Esc>', [[<Cmd>nohls<CR><Esc>]], { noremap = true })
-- vim.keymap.set('t', [[<C-\>]], [[<C-\><C-n>]], { noremap = true })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true })
-- vim.keymap.set('t', [[<Esc>]], [[<Esc>]], { noremap = true })
-- vim.keymap.set('t', [[jk]], [[<C-\><C-n>]], opts)

vim.keymap.set({'v', 'n'}, 'K', function ()
    vim.lsp.buf.hover()
end)

vim.keymap.set({'v', 'n'}, 'gK', function ()
    vim.lsp.buf.signature_help()
end)

vim.keymap.set({'v', 'n'}, 'gw', function ()
    vim.lsp.buf.code_action({
        -- context = {
        --     only = {
        --         "source",
        --     },
        --     diagnostics = {},
        -- },
        apply = true,
    })
end)
vim.keymap.set({'v', 'n'}, 'gn', function()
  return ":IncRename " .. vim.fn.expand("<cword>")
end, { expr = true })
vim.keymap.set({'v', 'n'}, 'gN', function()
  return ":IncRename "
end, { expr = true })
vim.keymap.set({'n'}, '<S-Tab>', '<C-o>')
vim.keymap.set({'i'}, '<C-Space>', '<Space>')

vim.keymap.set({'v', 'n'}, 'gp', ':GPT<Space>')
vim.keymap.set({'v', 'n'}, 'gP', ':GPT!<Space>')
vim.keymap.set({'i'}, '<C-Space>', '<Cmd>GPT<CR>')
vim.keymap.set({'i', 'n'}, '<C-t>', '<Cmd>-8,+8GPT refactor this code<CR>')
vim.keymap.set({'v'}, '<C-t>', '<Cmd>GPT refactor this code<CR>')

vim.cmd [[
augroup quickfix_setlocal
autocmd!
autocmd FileType qf setlocal wrap
\ | vnoremap <buffer> <F6> <cmd>cclose<CR>
\ | nnoremap <buffer> <F6> <cmd>cclose<CR>
\ | vnoremap <buffer> <F18> <cmd>cclose<CR>
\ | nnoremap <buffer> <F18> <cmd>cclose<CR>
\ | nnoremap <buffer> <Esc> <cmd>cclose<CR>
augroup END
]]

vim.cmd [[
augroup neogit_setlocal
autocmd!
autocmd FileType NeogitStatus nnoremap <buffer> <F10> <cmd>:q<CR>
augroup END
]]

-- if os.getenv('LOOPCOMMAND') then
--     vim.keymap.set('n', 'R', '<Cmd>R<CR>')
--     vim.api.nvim_create_user_command("R", function ()
--         vim.cmd [[
--         sil! UpdateRemotePlugins
--         wall!
--         cquit!
--         ]]
--     end, { desc = 'Restart NeoVim' })
-- end

return vim.keymap.set
