return {
  {
    'kndndrj/nvim-dbee',
    enabled = true,
    dependencies = { 'MunifTanjim/nui.nvim' },
    build = function()
      require('dbee').install()
    end,
    config = function()
      local source = require 'dbee.sources'
      require('dbee').setup {
        sources = {
          source.MemorySource:new({
            ---@diagnostic disable-next-line: missing-fields
            {
              type = 'postgres',
              name = 'metalworkingsolutions',
              url = 'postgresql://postgres:postgres@localhost:5432/metalworkingsolutions',
            },
          }, 'metalworkingsolutions'),
        },
      }
      require 'plugins.dbee'
    end,
  },
}
