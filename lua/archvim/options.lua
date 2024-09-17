vim.g.mapleader = ','

vim.cmd [[
set mouse=a
set mousemodel=extend
set updatetime=400
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
set termguicolors
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

-- vim.g_printed = ''
-- vim.g_print = function(msg)
--     vim.g_printed = vim.g_printed .. tostring(msg) .. '\n'
-- end
-- vim.g_dump = function()
--     print(vim.g_printed)
-- end

vim.lsp.set_log_level("off")

local opts = {
    nerd_fonts = true,
    transparent_color = true,
    more_cpp_ftdetect = true,
    enable_signature_help = true,
    enable_inlay_hint = true,
}

local function save_opts()
    local data_path = vim.fn.stdpath('data') .. '/archvim'
    if not vim.fn.isdirectory(data_path) then
        vim.fn.mkdir(data_path, 'p')
    end
    local file_name = data_path .. '/opts.json'
    local file = io.open(file_name, 'w')
    assert(file, string.format("cannot open file '%s' for write", file_name))
    file:write(vim.fn.json_encode(opts))
    file:close()
end

local function load_opts()
    local data_path = vim.fn.stdpath('data') .. '/archvim'
    local file_name = data_path .. '/opts.json'
    local file = io.open(file_name, 'r')
    if file then
        local content = file:read('*a')
        file:close()
        local ok, result = pcall(vim.fn.json_decode, content)
        if ok then
            for k, v in pairs(result) do
                opts[k] = v
            end
        end
    end
end

load_opts()

return setmetatable(opts, {
    __newindex = function (t, k, v)
        rawset(t, k, v)
        save_opts()
    end,
    __index = function (t, k)
        return rawget(t, k)
    end,
})
