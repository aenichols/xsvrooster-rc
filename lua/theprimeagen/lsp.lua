local sumneko_root_path = 'C:/Users/anthony.nichols/.vscode/extensions/sumneko.lua-1.20.4/server'
local sumneko_binary = sumneko_root_path .. "/bin/Windows/lua-language-server"

local on_attach = require'completion'.on_attach

require'lspconfig'.tsserver.setup{ on_attach=on_attach }

local probeLoc  = 'C:/Users/anthony.nichols/.vscode/extensions/angular.ng-template-11.2.11/node_modules'
local angularCmd = {"ngserver.cmd", "--stdio", "--tsProbeLocations", probeLoc , "--ngProbeLocations", probeLoc}

require'lspconfig'.angularls.setup{
  cmd = angularCmd ,
  on_new_config = function(new_config, new_root_dir)
    new_config.cmd = angularCmd
  end,
}

require'lspconfig'.clangd.setup {
    on_attach = on_attach,
    root_dir = function() return vim.loop.cwd() end
}

require'lspconfig'.sumneko_lua.setup {
    on_attach = on_attach,
    cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"};
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
                -- Setup your lua path
                path = vim.split(package.path, ';'),
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = {'vim'},
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = {
                    [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                    [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                },
            },
        },
    },
}

local pid = vim.fn.getpid()
-- On linux/darwin if using a release build, otherwise under scripts/OmniSharp(.Core)(.cmd)
local omnisharp_bin = "C:/OmniSharp/OmniSharp.exe"
-- on Windows
-- local omnisharp_bin = "/path/to/omnisharp/OmniSharp.exe"
require'lspconfig'.omnisharp.setup{
    cmd = { omnisharp_bin, "--languageserver" , "--hostPID", tostring(pid) };
    ...
}

