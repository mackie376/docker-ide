local api = vim.api
local cmd = vim.api.nvim_command
local autocmd = vim.api.nvim_create_autocmd

-- -------------------------------------------------------------------------

autocmd({ 'BufWritePre' }, {
  pattern = { '*' },
  callback = function()
    local pos = api.nvim_win_get_cursor(0)
    cmd('%s/ \\+$//ge')
    api.nvim_win_set_cursor(0, pos)

    if api.nvim_buf_line_count(0) > 1 then
      while api.nvim_buf_get_lines(0, -2, -1, true)[1] == '' do
        api.nvim_buf_set_lines(0, -2, -1, true, {})
      end
    end
  end,
})

-- -------------------------------------------------------------------------

autocmd({ 'TextYankPost' }, {
  pattern = { '*' },
  callback = function()
    vim.highlight.on_yank({ timeout = 100 })
  end,
})

-- -------------------------------------------------------------------------

autocmd({ 'InsertLeave' }, {
  pattern = { '*' },
  command = 'set nopaste',
})

-- -------------------------------------------------------------------------

autocmd({ 'TermOpen' }, {
  pattern = { '*' },
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    cmd('startinsert')
  end,
})

-- -------------------------------------------------------------------------

autocmd({ 'TermClose' }, {
  pattern = { '*' },
  callback = function()
    api.nvim_feedkeys("\\<Ignore>", 'm', false)
  end,
})
