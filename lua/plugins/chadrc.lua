return {
  {
    'nvchad/ui',
    config = function()
      require 'nvchad'
    end,
  },

  {
    'nvchad/base46',
    lazy = true,
    build = function()
      require('base46').load_all_highlights()
    end,
  },

  {
    'nvchad/volt', -- optional, needed for theme switcher
  },

  base46 = {
    theme = 'onedark',
    hl_add = {},
    hl_override = {},
    integrations = {},
    changed_themes = {},
    transparency = false,
    theme_toggle = { 'onedark', 'one_light' },
  },
}
