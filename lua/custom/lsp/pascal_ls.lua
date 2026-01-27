local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'

if not configs.pascal_ls then
  configs.pascal_ls = {
    default_config = {
      cmd = { 'PascalLanguageServer' },
      filetypes = { 'pascal' },
      root_dir = function()
        return vim.fn.getcwd()
      end,
      single_file_support = true,
    },
  }
end

lspconfig.pascal_ls.setup {}
