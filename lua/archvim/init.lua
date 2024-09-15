-- neovim 6.1 required

require('archvim.plugins')
require('archvim.mappings')
require('archvim.options')
require('archvim.custom')

function print(...)
    vim.notify(vim.inspect({...}))
end
