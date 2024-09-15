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
require'lspconfig'.lua_ls.setup{}
require'lspconfig'.cmake.setup{}
-- require'lspconfig'.rust_analyzer.setup{}

require('lspconfig').clangd.setup{
    on_new_config = function(new_config, new_cwd)
        local status, cmake = pcall(require, "cmake-tools")
        if status then
            cmake.clangd_on_new_config(new_config)
        end
    end,
}
