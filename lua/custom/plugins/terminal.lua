local last_opened = nil

local copilot_term = nil

local function get_copilot_terminal()
  if copilot_term == nil then
    local Terminal = require('toggleterm.terminal').Terminal

    local should_resume = vim.fn.input 'Resume a previous session? (y/n): '
    local cmd = 'copilot'
    if should_resume:lower() == 'y' then
      cmd = 'copilot --resume'
    end
    copilot_term = Terminal:new {
      cmd = cmd,
      direction = 'vertical',
      display_name = 'Copilot CLI',
      close_on_exit = true,
      on_close = function()
        -- Force the prompt again next time
        copilot_term = nil
      end,
    }
  end
  return copilot_term
end

local claude_terminal = nil

local function get_claude_terminal()
  if claude_terminal == nil then
    local Terminal = require('toggleterm.terminal').Terminal
    claude_terminal = Terminal:new {
      cmd = 'claude',
      direction = 'vertical',
      display_name = 'Claude Code',
      close_on_exit = true,
    }
  end
  return claude_terminal
end

local function new_shell(command, display_name)
  local toggleterm_terminal = require 'toggleterm.terminal'
  local Terminal = toggleterm_terminal.Terminal
  return Terminal:new {
    cmd = command,
    display_name = display_name,
    close_on_exit = true,
  }
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

        last_opened = term

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
    vim.keymap.set('n', '<leader>\\t', function()
      if last_opened ~= nil then
        last_opened:toggle()
      else
        get_main_shell():toggle()
      end
    end, { desc = '[T]oggle Most Recent Terminal or Main' })

    vim.keymap.set('n', '<leader>\\m', function()
      get_main_shell():toggle()
    end, { desc = 'Toggle [M]ain Shell Terminal' })

    vim.keymap.set('n', '<leader>\\g', function()
      get_copilot_terminal():toggle()
    end, { desc = 'Toggle [G]ithub Copilot CLI' })

    vim.keymap.set('n', '<leader>\\c', function()
      get_claude_terminal():toggle()
    end, { desc = 'Toggle [C]laude Code' })

    vim.keymap.set('n', '<leader>\\n', function()
      local shell_cmd = vim.fn.input('Enter shell command: ', '', 'file')
      if shell_cmd == '' then
        print 'No command entered. Aborting terminal creation.'
        return
      end
      -- Extract just the command name (without arguments)
      local cmd_name = shell_cmd:match '^(%S+)'
      if vim.fn.executable(cmd_name) == 0 then
        print('Error: "' .. cmd_name .. '" is not executable or not found in PATH.')
        return
      end
      local display_name = vim.fn.input('Enter terminal display name: ', shell_cmd, 'file')
      local new_terminal = new_shell(shell_cmd, display_name)
      new_terminal:open()
    end, { desc = 'Spawn [N]ew Custom Terminal' })
  end,
}
