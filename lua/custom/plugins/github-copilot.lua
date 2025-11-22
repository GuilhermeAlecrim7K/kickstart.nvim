return {
  'zbirenbaum/copilot.lua',
  dependencies = {
    {
      'copilotlsp-nvim/copilot-lsp',
      init = function()
        vim.g.copilot_nes_debounce = 3000
      end,
    },
  },
  cmd = 'Copilot',
  event = 'InsertEnter',
  lazy = true,
  opts = {
    filetypes = {
      ['*'] = false,
      c = true,
      cs = true,
      c_sharp = true,
      cpp = true,
      css = true,
      dart = true,
      dockerfile = true,
      go = true,
      html = true,
      java = true,
      javascript = true,
      lua = true,
      pas = true,
      pascal = true,
      powershell = true,
      python = true,
      vim = true,
    },
    panel = {
      enabled = true,
      auto_refresh = false,
      keymap = {
        jump_prev = 'gp',
        jump_next = 'gn',
        accept = '<CR>',
        refresh = 'gr',
        open = '<M-CR>',
      },
      layout = {
        position = 'right', -- | top | left | right | bottom |
        ratio = 0.4,
      },
    },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      hide_during_completion = true,
      debounce = 75,
      trigger_on_accept = true,
      keymap = {
        accept = '<M-y>',
        accept_word = '<M-l>',
        accept_line = false,
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
      },
    },
    nes = {
      -- BUG: Working terribly. NES always suggests code that I've already written.
      enabled = false, -- requires copilot-lsp as a dependency
      auto_trigger = true,
      keymap = {
        accept_and_goto = '<M-k>',
        accept = '<M-j>',
        dismiss = '<M-h>',
      },
    },
    auth_provider_url = nil, -- URL to authentication provider, if not "https://github.com/"
    copilot_node_command = 'node', -- Node.js version must be > 22
    workspace_folders = {},
    copilot_model = '',
    disable_limit_reached_message = false, -- Set to `true` to suppress completion limit reached popup
    root_dir = nil,
  },
}
