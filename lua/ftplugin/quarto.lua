-- local api = vim.api
-- local ts = vim.treesitter
--
-- vim.b.slime_cell_delimiter = '```'
-- vim.b['quarto_is_r_mode'] = nil
-- vim.b['reticulate_running'] = false
--
-- -- wrap text, but by word no character
-- -- indent the wrappped line
-- vim.wo.wrap = true
-- vim.wo.linebreak = true
-- vim.wo.breakindent = true
-- vim.wo.showbreak = '|'
--
-- -- don't run vim ftplugin on top
-- vim.api.nvim_buf_set_var(0, 'did_ftplugin', true)
--
-- -- markdown vs. quarto hacks
-- local ns = vim.api.nvim_create_namespace 'QuartoHighlight'
-- vim.api.nvim_set_hl(ns, '@markup.strikethrough', { strikethrough = false })
-- vim.api.nvim_set_hl(ns, '@markup.doublestrikethrough', { strikethrough = true })
-- vim.api.nvim_win_set_hl_ns(0, ns)
--
-- -- ts based code chunk highlighting uses a change
-- -- only availabl in nvim >= 0.10
-- if vim.fn.has 'nvim-0.10.0' == 0 then
--   return
-- end
--
-- -- highlight code cells similar to
-- -- 'lukas-reineke/headlines.nvim'
-- -- (disabled in lua/plugins/ui.lua)
-- local buf = api.nvim_get_current_buf()
--
-- local parsername = 'markdown'
-- local parser = ts.get_parser(buf, parsername)
-- local tsquery = '(fenced_code_block)@codecell'
--
-- -- vim.api.nvim_set_hl(0, '@markup.codecell', { bg = '#000055' })
-- vim.api.nvim_set_hl(0, '@markup.codecell', {
--   link = 'CursorLine',
-- })
--
-- local function clear_all()
--   local all = api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
--   for _, mark in ipairs(all) do
--     vim.api.nvim_buf_del_extmark(buf, ns, mark[1])
--   end
-- end
--
-- local function highlight_range(from, to)
--   for i = from, to do
--     vim.api.nvim_buf_set_extmark(buf, ns, i, 0, {
--       hl_eol = true,
--       line_hl_group = '@markup.codecell',
--     })
--   end
-- end
--
-- local function highlight_cells()
--   clear_all()
--
--   local query = ts.query.parse(parsername, tsquery)
--   local tree = parser:parse()
--   local root = tree[1]:root()
--   for _, match, _ in query:iter_matches(root, buf, 0, -1, { all = true }) do
--     for _, nodes in pairs(match) do
--       for _, node in ipairs(nodes) do
--         local start_line, _, end_line, _ = node:range()
--         pcall(highlight_range, start_line, end_line - 1)
--       end
--     end
--   end
-- end
--
-- highlight_cells()
--
-- vim.api.nvim_create_autocmd({ 'ModeChanged', 'BufWrite' }, {
--   group = vim.api.nvim_create_augroup('QuartoCellHighlight', { clear = true }),
--   buffer = buf,
--   callback = highlight_cells,
-- })

-- local api = vim.api
-- local ts = vim.treesitter
--
-- vim.b.slime_cell_delimiter = '```'
-- vim.b['quarto_is_r_mode'] = nil
-- vim.b['reticulate_running'] = false
--
-- -- wrap text, but by word no character
-- -- indent the wrappped line
-- vim.wo.wrap = true
-- vim.wo.linebreak = true
-- vim.wo.breakindent = true
-- vim.wo.showbreak = '|'
--
-- -- don't run vim ftplugin on top
-- vim.api.nvim_buf_set_var(0, 'did_ftplugin', true)
--
-- -- markdown vs. quarto hacks
-- local ns = vim.api.nvim_create_namespace 'QuartoHighlight'
-- vim.api.nvim_set_hl(ns, '@markup.strikethrough', { strikethrough = false })
-- vim.api.nvim_set_hl(ns, '@markup.doublestrikethrough', { strikethrough = true })
-- vim.api.nvim_win_set_hl_ns(0, ns)
--
-- -- ts based code chunk highlighting uses a change
-- -- only availabl in nvim >= 0.10
-- if vim.fn.has 'nvim-0.10.0' == 0 then
--   print 'Neovim version < 0.10.0 detected, code cell highlighting disabled'
--   return
-- end
--
-- -- highlight code cells similar to
-- -- 'lukas-reineke/headlines.nvim'
-- -- (disabled in lua/plugins/ui.lua)
-- local buf = api.nvim_get_current_buf()
-- local parsername = 'markdown'
-- local parser = ts.get_parser(buf, parsername)
-- local tsquery = '(fenced_code_block)@codecell'
--
-- -- Define highlight group with a distinctive color
-- vim.api.nvim_set_hl(0, '@markup.codecell', { link = 'CursorLine' })
--
-- local function clear_all()
--   local all = api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
--   for _, mark in ipairs(all) do
--     vim.api.nvim_buf_del_extmark(buf, ns, mark[1])
--   end
-- end
--
-- local function highlight_range(from, to)
--   for i = from, to do
--     vim.api.nvim_buf_set_extmark(buf, ns, i, 0, {
--       hl_eol = true,
--       line_hl_group = '@markup.codecell',
--     })
--   end
-- end
--
-- local function highlight_cells()
--   clear_all()
--
--   -- Check if the parser is valid
--   if not parser then
--     print 'TreeSitter parser not available'
--     return
--   end
--
--   local query = ts.query.parse(parsername, tsquery)
--   local tree = parser:parse()
--
--   if not tree or #tree == 0 then
--     print 'TreeSitter parse failed'
--     return
--   end
--
--   local root = tree[1]:root()
--
--   for _, match, _ in query:iter_matches(root, buf, 0, -1, { all = true }) do
--     for _, nodes in pairs(match) do
--       for _, node in ipairs(nodes) do
--         local start_line, _, end_line, _ = node:range()
--         local success, err = pcall(highlight_range, start_line, end_line - 1)
--         if not success then
--           print('Error highlighting range: ' .. tostring(err))
--         end
--       end
--     end
--   end
-- end
--
-- -- Initial highlighting
-- highlight_cells()
--
-- -- Setup autocmd for re-highlighting
-- vim.api.nvim_create_autocmd({ 'ModeChanged', 'BufWrite' }, {
--   group = vim.api.nvim_create_augroup('QuartoCellHighlight', { clear = true }),
--   buffer = buf,
--   callback = highlight_cells,
-- })
--
-- -- Also add FileType autocmd to ensure it runs for the right filetypes
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'quarto', 'markdown', 'rmd' },
--   callback = function()
--     if vim.bo.filetype ~= 'quarto' and vim.bo.filetype ~= 'markdown' and vim.bo.filetype ~= 'rmd' then
--       return
--     end
--     highlight_cells()
--   end,
--   group = vim.api.nvim_create_augroup('QuartoCellHighlightFileType', { clear = true }),
-- })
--
-- -- Print a message to confirm the script has loaded
-- print 'Quarto highlighting loaded'

-- debugging script below
local api = vim.api
local ts = vim.treesitter

-- Add debug logging function
local function debug_log(msg)
  vim.notify('[Quarto Debug] ' .. msg, vim.log.levels.INFO)
end

-- Initial debug message
debug_log 'Loading quarto.lua'

-- Check Neovim version first
local nvim_version = vim.version()
debug_log('Neovim version: ' .. nvim_version.major .. '.' .. nvim_version.minor .. '.' .. nvim_version.patch)

-- Check if treesitter is available
if not ts then
  debug_log 'ERROR: TreeSitter module not available'
  return
end

vim.b.slime_cell_delimiter = '```'
vim.b['quarto_is_r_mode'] = nil
vim.b['reticulate_running'] = false

-- wrap text settings
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.breakindent = true
vim.wo.showbreak = '|'

-- don't run vim ftplugin on top
vim.api.nvim_buf_set_var(0, 'did_ftplugin', true)

-- Create namespace with a unique name
local ns = vim.api.nvim_create_namespace 'QuartoHighlight_Debug'
debug_log('Created namespace: ' .. ns)

-- Set highlight groups both in namespace and global
debug_log 'Setting up highlight groups'
vim.api.nvim_set_hl(0, '@markup.codecell', { bg = '#303030' })
vim.api.nvim_set_hl(ns, '@markup.codecell', { bg = '#303030' })

-- Try both with and without the namespace highlight
vim.api.nvim_win_set_hl_ns(0, ns)

-- Early return check with debug message
if vim.fn.has 'nvim-0.10.0' == 0 then
  debug_log 'ERROR: Neovim version < 0.10.0 detected, code cell highlighting requires 0.10.0+'
  return
end

local buf = api.nvim_get_current_buf()
debug_log('Current buffer: ' .. buf)

-- Check filetype
local filetype = vim.bo.filetype
debug_log('Current filetype: ' .. filetype)

-- Check if this is a compatible filetype
if not (filetype == 'quarto' or filetype == 'markdown' or filetype == 'rmd') then
  debug_log('WARNING: Filetype ' .. filetype .. ' may not be compatible with highlighting')
end

-- Set up TreeSitter
local parsername = 'markdown'
debug_log('Attempting to get parser for: ' .. parsername)

local parser_ok, parser = pcall(ts.get_parser, buf, parsername)
if not parser_ok then
  debug_log('ERROR: Failed to get parser: ' .. tostring(parser))
  return
end

if not parser then
  debug_log 'ERROR: Parser is nil'
  return
end

debug_log 'Parser initialized successfully'

local tsquery = '(fenced_code_block)@codecell'
debug_log('Using query: ' .. tsquery)

local function clear_all()
  debug_log 'Clearing all extmarks'
  local all = api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
  debug_log('Found ' .. #all .. ' existing extmarks')
  for _, mark in ipairs(all) do
    local ok, err = pcall(vim.api.nvim_buf_del_extmark, buf, ns, mark[1])
    if not ok then
      debug_log('Error deleting extmark: ' .. tostring(err))
    end
  end
end

local function highlight_range(from, to)
  debug_log('Highlighting range: ' .. from .. ' to ' .. to)
  for i = from, to do
    local ok, err = pcall(vim.api.nvim_buf_set_extmark, buf, ns, i, 0, {
      hl_eol = true,
      line_hl_group = '@markup.codecell',
    })
    if not ok then
      debug_log('Error setting extmark at line ' .. i .. ': ' .. tostring(err))
    end
  end
end

local function highlight_cells()
  debug_log 'Starting highlight_cells()'
  clear_all()

  -- Re-check if the parser is valid
  if not parser then
    debug_log 'ERROR: Parser is nil in highlight_cells()'
    return
  end

  local query_ok, query = pcall(ts.query.parse, parsername, tsquery)
  if not query_ok then
    debug_log('ERROR: Failed to parse query: ' .. tostring(query))
    return
  end

  debug_log 'Query parsed successfully'

  local tree_ok, tree = pcall(function()
    return parser:parse()
  end)
  if not tree_ok then
    debug_log('ERROR: Failed to parse tree: ' .. tostring(tree))
    return
  end

  if not tree or #tree == 0 then
    debug_log 'ERROR: Tree is empty'
    return
  end

  debug_log('Tree parsed successfully, found ' .. #tree .. ' trees')

  local root = tree[1]:root()
  debug_log 'Got root node'

  local matches_found = 0
  for _, match, _ in query:iter_matches(root, buf, 0, -1, { all = true }) do
    for id, nodes in pairs(match) do
      debug_log('Found match for id: ' .. id)
      for _, node in ipairs(nodes) do
        local start_line, _, end_line, _ = node:range()
        debug_log('Node range: ' .. start_line .. ' to ' .. end_line)
        local success, err = pcall(highlight_range, start_line, end_line - 1)
        if not success then
          debug_log('ERROR: Failed to highlight range: ' .. tostring(err))
        end
        matches_found = matches_found + 1
      end
    end
  end

  debug_log('Total matches found: ' .. matches_found)

  if matches_found == 0 then
    debug_log 'WARNING: No code cells found to highlight'
  end
end

-- Initial highlighting
debug_log 'Performing initial highlighting'
highlight_cells()

-- Setup autocmd for re-highlighting
debug_log 'Setting up autocmds'
local highlight_group = vim.api.nvim_create_augroup('QuartoCellHighlight_Debug', { clear = true })
vim.api.nvim_create_autocmd({ 'ModeChanged', 'BufWrite' }, {
  group = highlight_group,
  buffer = buf,
  callback = function()
    debug_log 'Autocmd triggered: ModeChanged/BufWrite'
    highlight_cells()
  end,
})

-- Also add FileType autocmd
local filetype_group = vim.api.nvim_create_augroup('QuartoCellHighlightFileType_Debug', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'quarto', 'markdown', 'rmd' },
  group = filetype_group,
  callback = function()
    debug_log('Autocmd triggered: FileType ' .. vim.bo.filetype)
    if vim.bo.filetype ~= 'quarto' and vim.bo.filetype ~= 'markdown' and vim.bo.filetype ~= 'rmd' then
      debug_log 'Skipping incompatible filetype'
      return
    end
    highlight_cells()
  end,
})

-- Try to force a redraw
vim.cmd 'redraw'

debug_log 'Quarto highlighting script loaded successfully'
