return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    indent = {
      enabled = true,
      only_scope = true,
      animate = { enabled = false },
      scope = { only_current = true },
    },
    input = { enabled = true },
    lazygit = { enabled = true },
    quickfiles = { enabled = true },
    scope = { enabled = true },
    ---@class snacks.notifier.Config
    notifier = {
      enabled = true,
      top_down = false,
    },
    -- rename = { enabled = true }, -- TODO: check back later
    -- zen = { enabled = true }, -- TODO: check back later
    image = {
      formats = {
        'png',
        'jpg',
        'jpeg',
        'gif',
        'bmp',
        'webp',
        'tiff',
        'heic',
        'avif',
        'mp4',
        'mov',
        'avi',
        'mkv',
        'webm',
        -- 'pdf',
        'icns',
      },
    },
  },
}
