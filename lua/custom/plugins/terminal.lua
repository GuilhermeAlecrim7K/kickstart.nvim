local copilot_term = nil

local function get_copilot_terminal()
  if copilot_term == nil then
    local Terminal = require('toggleterm.terminal').Terminal
    copilot_term = Terminal:new {
      cmd = 'copilot',
      direction = 'vertical',
      display_name = 'Copilot CLI',
      close_on_exit = true,
    }
  end
  return copilot_term
end

local main_shell = nil

local function get_main_shell()
  if main_shell == nil then
    local Terminal = require('toggleterm.terminal').Terminal
    main_shell = Terminal:new {
      display_name = 'PowerShell',
      close_on_exit = true,
    }
  end
  return main_shell
end

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  event = 'VeryLazy',
  config = function()
    require('toggleterm').setup {
      size = function(term)
        if term.direction == 'horizontal' then
          return vim.o.lines * 0.35
        elseif term.direction == 'vertical' then
          return vim.o.columns * 0.35
        else
          return 20
        end
      end,
      autochdir = true,
      start_in_insert = false,
      direction = 'float',
    }

    local toggleterm_terminal = require 'toggleterm.terminal'

    -- Preload main shell terminal
    get_main_shell():spawn()

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'toggleterm',
      callback = function(args)
        local id = toggleterm_terminal.get_focused_id()
        if id == nil then
          return
        end

        local term = toggleterm_terminal.get(id, true)
        if term == nil then
          return
        end

        local function force_direction(new_direction)
          if not term:is_open() then
            term:open(nil, new_direction)
          elseif term.direction ~= new_direction then
            term:close()
            term:open(nil, new_direction)
          end
        end

        -- keymaps to switch terminal visualization
        vim.keymap.set('n', '<leader>\\f', function()
          force_direction 'float'
        end, { buffer = args.buf, desc = 'Switch to [F]loating Visualization' })
        vim.keymap.set('n', '<leader>\\v', function()
          force_direction 'vertical'
        end, { buffer = args.buf, desc = 'Switch to [V]ertical Visualization' })
        vim.keymap.set('n', '<leader>\\h', function()
          force_direction 'horizontal'
        end, { buffer = args.buf, desc = 'Switch to [H]orizontal Visualization' })
      end,
    })

    -- TODO: Personalize picker shortcuts (delete, rename?, open as float/vert/horiz)
    vim.keymap.set('n', '<leader>\\s', '<cmd>TermSelect<cr>', { desc = '[S]elect Terminal Session' })
    vim.keymap.set('n', '<leader>\\t', '<cmd>ToggleTerm<cr>', { desc = 'Toggle [T]erminal' })
    vim.keymap.set('n', '<leader>\\m', function()
      get_main_shell():toggle()
    end, { desc = 'Toggle [M]ain Shell Terminal' })
    vim.keymap.set('n', '<leader>\\c', function()
      get_copilot_terminal():toggle()
    end, { desc = 'Toggle [C]opilot Terminal' })
  end,
}
