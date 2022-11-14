local keymap = vim.keymap.set

-- -------------------------------------------------------------------------

vim.g.mapleader = ' '

-- -------------------------------------------------------------------------

keymap('n', '[buffer]',  '<nop>', { silent = false })
keymap('n', '[execute]', '<nop>', { silent = false })
keymap('n', '[file]',    '<nop>', { silent = false })
keymap('n', '[git]',     '<nop>', { silent = false })
keymap('n', '[help]',    '<nop>', { silent = false })
keymap('n', '[lsp]',     '<nop>', { silent = false })
keymap('n', '[project]', '<nop>', { silent = false })
keymap('n', '[quit]',    '<nop>', { silent = false })
keymap('n', '[search]',  '<nop>', { silent = false })
keymap('n', '[view]',    '<nop>', { silent = false })

keymap('n', '<leader>b', '[buffer]',  { remap = true, silent = false })
keymap('n', '<leader>f', '[file]',    { remap = true, silent = false })
keymap('n', '<leader>g', '[git]',     { remap = true, silent = false })
keymap('n', '<leader>h', '[help]',    { remap = true, silent = false })
keymap('n', '<leader>l', '[lsp]',     { remap = true, silent = false })
keymap('n', '<leader>p', '[project]', { remap = true, silent = false })
keymap('n', '<leader>q', '[quit]',    { remap = true, silent = false })
keymap('n', '<leader>s', '[search]',  { remap = true, silent = false })
keymap('n', '<leader>v', '[view]',    { remap = true, silent = false })
keymap('n', '<leader>x', '[execute]', { remap = true, silent = false })

keymap('n', '<esc><esc>', '<cmd>nohlsearch<cr><esc>')
keymap('n', 'x',          '"_x')
keymap('n', 'D',          '"_D')
keymap('n', '<c-w>/',     '<cmd>vs<cr><c-w>l')
keymap('n', '<c-w>-',     '<cmd>sp<cr><c-w>j')

keymap('i', 'jk',         '<esc>')

keymap('t', '<c-g>',      '<c-\\><c-n>')

keymap('n', '[buffer]c', '<cmd>bp | sp | bn | bd<cr>')
keymap('n', '[buffer]d', '<cmd>bp | sp | bn | bd<cr>')
keymap('n', '[buffer]n', '<cmd>bn<cr>')
keymap('n', '[buffer]p', '<cmd>bp<cr>')

keymap('n', '[execute]s', '<cmd>term<cr>')

keymap('n', '[file]s', '<cmd>write<cr>')

keymap('n', '[quit]Q', '<cmd>qall!<cr>')
keymap('n', '[quit]q', '<cmd>wqall<cr>')
