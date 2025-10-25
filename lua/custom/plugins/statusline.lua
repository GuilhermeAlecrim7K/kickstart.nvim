return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'rmagatti/auto-session' },
  opts = {
    options = {
      theme = 'dracula',
    },
    extensions = { 'oil', 'fzf', 'lazy', 'man', 'mason', 'quickfix' },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        {
          'filename',
          file_status = true, -- Displays file status (readonly status, modified status)
          newfile_status = false, -- Display new file status (new file means no write after created)
          path = 1, -- 0: Just the filename
          -- 1: Relative path
          -- 2: Absolute path
          -- 3: Absolute path, with tilde as the home directory
          -- 4: Filename and parent dir, with tilde as the home directory

          -- shorting_target = 40, -- Shortens path to leave 40 spaces in the window
          -- for other components. (terrible name, any suggestions?)
          symbols = {
            modified = '[+]', -- Text to show when the file is modified.
            readonly = '[R]', -- Text to show when the file is non-modifiable or readonly.
            unnamed = '[No Name]', -- Text to show for unnamed buffers.
            newfile = '[New]', -- Text to show for newly created file before first write
          },
        },
      },
      -- TODO: Add a function to one of the sections that parses results from svn
      lualine_c = {
        function()
          local session_name = require('auto-session.lib').current_session_name(true)
          if session_name and session_name ~= '' then
            return '\u{1f517} ' .. session_name
          else
            return '\u{26aa}'
          end
        end,
        'branch',
        'diff',
        'diagnostics',
      },
      lualine_x = {},
      lualine_y = { 'encoding', 'fileformat', { 'filetype', icon_only = true } },
      lualine_z = { 'selectioncount', { 'searchcount', maxcount = 999999, timeout = 500 }, 'progress', 'location' },
    },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      {
        'filename',
        file_status = true,
        symbols = {
          modified = '[+]', -- Text to show when the file is modified.
          readonly = '[R]', -- Text to show when the file is non-modifiable or readonly.
          unnamed = '[No Name]', -- Text to show for unnamed buffers.
          newfile = '[New]', -- Text to show for newly created file before first write
        },
      },
    },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
}
