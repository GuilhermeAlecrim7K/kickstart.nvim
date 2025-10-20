return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'rmagatti/auto-session' },
  opts = {
    options = {
      theme = 'dracula',
    },
    extensions = { 'oil' },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = {
        function()
          local session_name = require('auto-session.lib').current_session_name(true)
          if session_name and session_name ~= '' then
            return 'Auto-Session: ' .. session_name
          else
            return 'Detached'
          end
        end,
        'branch',
        'diff',
        'diagnostics',
      },
      -- TODO: Add a function to lualine_c that parses results from svn
      lualine_c = {
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
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'selectioncount', { 'searchcount', maxcount = 999999, timeout = 500 }, 'progress', 'location' },
      lualine_z = { 'datetime' },
    },
  },
}
