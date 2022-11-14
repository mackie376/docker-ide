local opt = vim.opt

-- global
opt.clipboard      = 'unnamed,unnamedplus'
opt.cmdheight      = 2
opt.completeopt    = 'menu,menuone,noselect'
opt.fileencodings  = 'utf-8,euc,noselect'
opt.fileformats    = 'unix,mac,dos'
opt.hidden         = true
opt.ignorecase     = true
opt.inccommand     = 'split'
opt.laststatus     = 2
opt.path:append({ '**' })
opt.showmode       = false
opt.scrolloff      = 5
opt.shortmess:append('c')
opt.smartcase      = true
opt.termguicolors  = true
opt.timeoutlen     = 1000
opt.title          = true
opt.ttimeoutlen    = 1
opt.updatetime     = 200
opt.visualbell     = true
opt.whichwrap      = 'b,s,<,>,[,]'
opt.wildignore:append({ '*/node_modules/*' })
opt.wrapscan       = true

-- window
opt.cursorline     = true
opt.list           = true
opt.listchars      = 'tab:»-,trail:-'
opt.number         = true
opt.numberwidth    = 5
opt.relativenumber = true
opt.signcolumn     = 'yes'

-- buffer
opt.expandtab      = true
opt.shiftwidth     = 2
opt.smartindent    = true
opt.softtabstop    = 2
opt.swapfile       = true
opt.tabstop        = 2
