require'genius'.setup {
    default_bot = 'openai',
    completion_delay_ms = -1,
    -- config_openai = {
    --     base_url = "http://127.0.0.1:8080/https://api.openai.com",
    --     api_key = os.getenv("OPENAI_API_KEY"),
    -- },
}

vim.cmd [[
inoremap <C-Space> <Cmd>GeniusComplete<CR>
]]
