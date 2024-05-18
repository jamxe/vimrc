local function pyright_on_attach(client, bufnr)
    local function organize_imports()
        local params = {
            command = 'pyright.organizeimports',
            arguments = { vim.uri_from_bufnr(0) },
        }
        vim.lsp.buf.execute_command(params)
    end

    if client.name == "pyright" then
        vim.api.nvim_create_user_command("PyrightOrganizeImports", organize_imports, {desc = 'Organize Imports'})
    end
end

require'lspconfig'.pyright.setup{
    on_attach = pyright_on_attach,
}
-- require'lspconfig'.clangd.setup{}
require'lspconfig'.lua_ls.setup{}
require'lspconfig'.rust_analyzer.setup{}
require'lspconfig'.cmake.setup{}
require'lspconfig'.tsserver.setup{}

require('lspconfig').clangd.setup{
    on_new_config = function(new_config, new_cwd)
        local status, cmake = pcall(require, "cmake-tools")
        if status then
            cmake.clangd_on_new_config(new_config)
        end
    end,
}

-- require "lsp_signature".setup({
--     bind = true,
--     handler_opts = {
--         border = "none",
--     },
--     floating_window = false,
--     floating_window_above_cur_line = false,
--     floating_window_off_x = 0,
--     floating_window_off_y = 0,
--     fix_pos = true,
--     hint_prefix = os.getenv("NERD_FONTS") and " " or "",
--     -- hint_prefix = "",
--     hint_scheme = "Comment",
--     debug = false,
--     toggle_key = '<M-x>',
--     toggle_key_flip_floatwin_setting = false,
-- })
