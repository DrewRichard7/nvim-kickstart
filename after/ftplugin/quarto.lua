local api = vim.api
local ts = vim.treesitter

vim.b.slime_cell_delimiter = '```'
vim.b['quarto_is_r_mode'] = nil
vim.b['reticulate_running'] = false

-- wrap text, but by word no character
-- indent the wrappped line
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.breakindent = true
vim.wo.showbreak = '|'

-- don't run vim ftplugin on top
vim.api.nvim_buf_set_var(0, 'did_ftplugin', true)

-- markdown vs. quarto hacks
local ns = vim.api.nvim_create_namespace 'QuartoHighlight'
vim.api.nvim_set_hl(ns, '@markup.strikethrough', { strikethrough = false })
vim.api.nvim_set_hl(ns, '@markup.doublestrikethrough', { strikethrough = true })
vim.api.nvim_win_set_hl_ns(0, ns)

-- ts based code chunk highlighting uses a change
-- only availabl in nvim >= 0.10
if vim.fn.has 'nvim-0.10.0' == 0 then
  return
end

-- highlight code cells similar to
-- 'lukas-reineke/headlines.nvim'
-- (disabled in lua/plugins/ui.lua)
local buf = api.nvim_get_current_buf()

local parsername = 'markdown'
local parser = ts.get_parser(buf, parsername)
local tsquery = '(fenced_code_block)@codecell'

-- vim.api.nvim_set_hl(0, '@markup.codecell', { bg = '#000055' })
vim.api.nvim_set_hl(0, '@markup.codecell', {
  link = 'CursorLine',
})

local function clear_all()
  local all = api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
  for _, mark in ipairs(all) do
    vim.api.nvim_buf_del_extmark(buf, ns, mark[1])
  end
end

local function highlight_range(from, to)
  for i = from, to do
    vim.api.nvim_buf_set_extmark(buf, ns, i, 0, {
      hl_eol = true,
      line_hl_group = '@markup.codecell',
    })
  end
end

local function highlight_cells()
  clear_all()

  local query = ts.query.parse(parsername, tsquery)
  local tree = parser:parse()
  local root = tree[1]:root()
  for _, match, _ in query:iter_matches(root, buf, 0, -1, { all = true }) do
    for _, nodes in pairs(match) do
      for _, node in ipairs(nodes) do
        local start_line, _, end_line, _ = node:range()
        pcall(highlight_range, start_line, end_line - 1)
      end
    end
  end
end

highlight_cells()

vim.api.nvim_create_autocmd({ 'ModeChanged', 'BufWrite' }, {
  group = vim.api.nvim_create_augroup('QuartoCellHighlight', { clear = true }),
  buffer = buf,
  callback = highlight_cells,
})

local api = vim.api
local ts = vim.treesitter

vim.b.slime_cell_delimiter = '```'
vim.b['quarto_is_r_mode'] = nil
vim.b['reticulate_running'] = false

-- wrap text, but by word no character
-- indent the wrappped line
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.breakindent = true
vim.wo.showbreak = '|'

-- don't run vim ftplugin on top
vim.api.nvim_buf_set_var(0, 'did_ftplugin', true)

-- markdown vs. quarto hacks
local ns = vim.api.nvim_create_namespace 'QuartoHighlight'
vim.api.nvim_set_hl(ns, '@markup.strikethrough', { strikethrough = false })
vim.api.nvim_set_hl(ns, '@markup.doublestrikethrough', { strikethrough = true })
vim.api.nvim_win_set_hl_ns(0, ns)

-- ts based code chunk highlighting uses a change
-- only availabl in nvim >= 0.10
if vim.fn.has 'nvim-0.10.0' == 0 then
  print 'Neovim version < 0.10.0 detected, code cell highlighting disabled'
  return
end

-- highlight code cells similar to
-- 'lukas-reineke/headlines.nvim'
-- (disabled in lua/plugins/ui.lua)
local buf = api.nvim_get_current_buf()
local parsername = 'markdown'
local parser = ts.get_parser(buf, parsername)
local tsquery = '(fenced_code_block)@codecell'

-- Define highlight group with a distinctive color
vim.api.nvim_set_hl(0, '@markup.codecell', { link = 'CursorLine' })

local function clear_all()
  local all = api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
  for _, mark in ipairs(all) do
    vim.api.nvim_buf_del_extmark(buf, ns, mark[1])
  end
end

local function highlight_range(from, to)
  for i = from, to do
    vim.api.nvim_buf_set_extmark(buf, ns, i, 0, {
      hl_eol = true,
      line_hl_group = '@markup.codecell',
    })
  end
end

local function highlight_cells()
  clear_all()

  -- Check if the parser is valid
  if not parser then
    print 'TreeSitter parser not available'
    return
  end

  local query = ts.query.parse(parsername, tsquery)
  local tree = parser:parse()

  if not tree or #tree == 0 then
    print 'TreeSitter parse failed'
    return
  end

  local root = tree[1]:root()

  for _, match, _ in query:iter_matches(root, buf, 0, -1, { all = true }) do
    for _, nodes in pairs(match) do
      for _, node in ipairs(nodes) do
        local start_line, _, end_line, _ = node:range()
        local success, err = pcall(highlight_range, start_line, end_line - 1)
        if not success then
          print('Error highlighting range: ' .. tostring(err))
        end
      end
    end
  end
end

-- Initial highlighting
highlight_cells()

-- Setup autocmd for re-highlighting
vim.api.nvim_create_autocmd({ 'ModeChanged', 'BufWrite' }, {
  group = vim.api.nvim_create_augroup('QuartoCellHighlight', { clear = true }),
  buffer = buf,
  callback = highlight_cells,
})

-- Also add FileType autocmd to ensure it runs for the right filetypes
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'quarto', 'markdown', 'rmd' },
  callback = function()
    if vim.bo.filetype ~= 'quarto' and vim.bo.filetype ~= 'markdown' and vim.bo.filetype ~= 'rmd' then
      return
    end
    highlight_cells()
  end,
  group = vim.api.nvim_create_augroup('QuartoCellHighlightFileType', { clear = true }),
})

-- Print a message to confirm the script has loaded
print 'Quarto highlighting loaded'

-- below was a debugging version of the above
-- local api = vim.api
-- local ts = vim.treesitter
--
-- -- Use buffer-local variable but respect any global setting
-- vim.b.slime_cell_delimiter = vim.g.slime_cell_delimiter or '```'
-- vim.b['quarto_is_r_mode'] = nil
-- vim.b['reticulate_running'] = false
--
-- -- wrap text, but by word no character
-- -- indent the wrapped line
-- vim.wo.wrap = true
-- vim.wo.linebreak = true
-- vim.wo.breakindent = true
-- vim.wo.showbreak = '|'
--
-- -- don't run vim ftplugin on top
-- vim.api.nvim_buf_set_var(0, 'did_ftplugin', true)
--
-- -- Print filetype for debugging
-- print('Current filetype: ' .. vim.bo.filetype)
--
-- -- Create namespace
-- local ns = vim.api.nvim_create_namespace 'QuartoHighlight'
--
-- -- markdown vs. quarto hacks
-- vim.api.nvim_set_hl(0, '@markup.strikethrough', { strikethrough = false })
-- vim.api.nvim_set_hl(0, '@markup.doublestrikethrough', { strikethrough = true })
-- vim.api.nvim_set_hl(0, '@markup.codecell', { bg = '#303030' }) -- Add a clearly visible background color
--
-- -- Set namespace for current window
-- vim.api.nvim_win_set_hl_ns(0, ns)
--
-- -- If you're on Neovim < 0.10, use a simpler approach that doesn't rely on TreeSitter
-- if vim.fn.has 'nvim-0.10.0' == 0 then
--   print 'Neovim < 0.10.0 detected, using simple regex-based highlighting'
--
--   local buf = api.nvim_get_current_buf()
--
--   -- Function to clear existing highlights
--   local function clear_all()
--     local all = api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
--     for _, mark in ipairs(all) do
--       pcall(vim.api.nvim_buf_del_extmark, buf, ns, mark[1])
--     end
--   end
--
--   -- Function to highlight a range of lines
--   local function highlight_range(from, to)
--     for i = from, to do
--       pcall(vim.api.nvim_buf_set_extmark, buf, ns, i, 0, {
--         hl_eol = true,
--         line_hl_group = '@markup.codecell',
--       })
--     end
--   end
--
--   -- Simple regex-based highlighting
--   local function highlight_code_blocks_simple()
--     -- Clear existing highlights
--     clear_all()
--
--     -- Get buffer content
--     local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
--
--     local in_code_block = false
--     local start_line = 0
--
--     for i, line in ipairs(lines) do
--       -- Check for code fence markers
--       if line:match '^```' then
--         if not in_code_block then
--           -- Start of code block
--           in_code_block = true
--           start_line = i - 1
--         else
--           -- End of code block
--           in_code_block = false
--           -- Highlight the range
--           highlight_range(start_line, i - 1)
--         end
--       end
--     end
--   end
--
--   -- Initial highlighting
--   highlight_code_blocks_simple()
--
--   -- Set up autocmds
--   local group = vim.api.nvim_create_augroup('QuartoCellHighlight', { clear = true })
--
--   vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWrite', 'TextChanged', 'InsertLeave' }, {
--     group = group,
--     buffer = buf,
--     callback = highlight_code_blocks_simple,
--   })
--
--   -- Add a command to manually trigger highlighting
--   vim.api.nvim_create_user_command('HighlightCodeBlocks', highlight_code_blocks_simple, {})
--
--   return
-- end
--
-- -- TreeSitter-based approach for Neovim >= 0.10.0
-- local buf = api.nvim_get_current_buf()
-- local parsername = 'markdown'
--
-- -- Try to get the parser, print error if it fails
-- local parser_ok, parser = pcall(ts.get_parser, buf, parsername)
-- if not parser_ok then
--   print('Failed to get parser: ' .. tostring(parser))
--   return
-- end
--
-- if not parser then
--   print 'Parser is nil'
--   return
-- end
--
-- -- Try different query syntax
-- local tsquery = '(fenced_code_block) @codecell'
--
-- local function clear_all()
--   local all = api.nvim_buf_get_extmarks(buf, ns, 0, -1, {})
--   for _, mark in ipairs(all) do
--     pcall(vim.api.nvim_buf_del_extmark, buf, ns, mark[1])
--   end
-- end
--
-- local function highlight_range(from, to)
--   for i = from, to do
--     pcall(vim.api.nvim_buf_set_extmark, buf, ns, i, 0, {
--       hl_eol = true,
--       line_hl_group = '@markup.codecell',
--     })
--   end
-- end
--
-- local function highlight_cells()
--   clear_all()
--
--   if not parser then
--     print 'TreeSitter parser not available'
--     return
--   end
--
--   local query_ok, query = pcall(ts.query.parse, parsername, tsquery)
--   if not query_ok then
--     print('Failed to parse query: ' .. tostring(query))
--     return
--   end
--
--   local tree = parser:parse()
--
--   if not tree or #tree == 0 then
--     print 'TreeSitter parse failed'
--     return
--   end
--
--   local root = tree[1]:root()
--   local match_count = 0
--
--   for _, match, _ in query:iter_matches(root, buf, 0, -1, { all = true }) do
--     for _, nodes in pairs(match) do
--       for _, node in ipairs(nodes) do
--         local start_line, _, end_line, _ = node:range()
--         local success, err = pcall(highlight_range, start_line, end_line - 1)
--         if not success then
--           print('Error highlighting range: ' .. tostring(err))
--         else
--           match_count = match_count + 1
--         end
--       end
--     end
--   end
--
--   print('Found ' .. match_count .. ' code blocks to highlight')
--
--   -- If no matches found with TreeSitter, fall back to regex
--   if match_count == 0 then
--     print 'No TreeSitter matches, falling back to regex'
--     highlight_code_blocks_simple()
--   end
-- end
--
-- -- Define the regex fallback function even for Neovim >= 0.10
-- -- This allows us to use it as a fallback if TreeSitter fails
-- local function highlight_code_blocks_simple()
--   -- Clear existing highlights
--   clear_all()
--
--   -- Get buffer content
--   local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
--
--   local in_code_block = false
--   local start_line = 0
--   local match_count = 0
--
--   for i, line in ipairs(lines) do
--     -- Check for code fence markers
--     if line:match '^```' then
--       if not in_code_block then
--         -- Start of code block
--         in_code_block = true
--         start_line = i - 1
--       else
--         -- End of code block
--         in_code_block = false
--         -- Highlight the range
--         highlight_range(start_line, i - 1)
--         match_count = match_count + 1
--       end
--     end
--   end
--
--   print('Found ' .. match_count .. ' code blocks using regex')
-- end
--
-- -- Initial highlighting
-- highlight_cells()
--
-- -- Set up autocmds
-- local group = vim.api.nvim_create_augroup('QuartoCellHighlight', { clear = true })
--
-- vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWrite', 'TextChanged', 'InsertLeave' }, {
--   group = group,
--   buffer = buf,
--   callback = highlight_cells,
-- })
--
-- -- Force redraw to make sure highlights are visible
-- vim.cmd 'redraw'
--
-- -- Add a command to manually trigger highlighting
-- vim.api.nvim_create_user_command('HighlightCodeBlocks', highlight_cells, {})
--
-- print 'Quarto highlighting loaded'
