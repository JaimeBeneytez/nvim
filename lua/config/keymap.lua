local g = vim.g
local km = vim.keymap

-- Leader
g.mapleader = ' '

-- set escape in touchbar macbooks
km.set({ 'i', 'v', 'n', 's', 'x' }, '§', '<esc>', { desc = 'Escape in touchbar macbooks' })

-- clear search highlights
km.set('n', '<leader>nh', ':nohl<CR>', { desc = 'Clear search highlights' })

-- buffer admin and navigation
km.set('n', '<leader>bn', ':bn<CR>', { desc = 'Next buffer' })
km.set('n', '<leader>bp', ':bp<CR>', { desc = 'Prevous buffer' })
km.set('n', '<leader>bn', ':bd<CR>', { desc = 'Delete buffer' })
km.set('n', '<leader>q', ':q<CR>', { desc = 'Close buffer' })
km.set('n', '<leader>w', ':w<CR>', { desc = 'Write buffer' })
km.set('n', '<leader>wq', ':wq<CR>', { desc = 'Write and close buffer' })
km.set('n', '<leader>Q', ':qall!<CR>', { desc = 'Close all buffers' })
km.set('n', '<leader>e', ':e<CR>', { desc = 'Reload buffer' })

km.set('n', '<leader>c', 'yaw :%s/<C-R><C-W>/', { desc = 'Substitute word under cursor' })
km.set('n', '<leader>E', ":e <C-R>=expand('%:p:h') . ' / '<CR>", { desc = 'Explore' })

km.set('n', '<leader>o', ':!open %:p:h<CR>', { desc = 'Open finder in folder', silent = true })

km.set('n', '<leader>sht', ':vsp<cr> :args %:p:h/*.html    <cr><cr>', { desc = 'Open .html on a vertical split' })
km.set('n', '<leader>sts', ':vsp<cr> :args %:p:h/*.ts      <cr><cr>', { desc = 'Open .ts on a vertical split' })
km.set('n', '<leader>sjs', ':vsp<cr> :args %:p:h/*.js      <cr><cr>', { desc = 'Open .js on a vertical split' })
km.set('n', '<leader>ssp', ':vsp<cr> :args %:p:h/*.spec.js <cr><cr>', { desc = 'Open .spec.js on a vertical split' })
km.set('n', '<leader>ssc', ':vsp<cr> :args %:p:h/*.scss    <cr><cr>', { desc = 'Open .scss on a vertical split' })
km.set('n', '<leader>sle', ':vsp<cr> :args %:p:h/*.less    <cr><cr>', { desc = 'Open .less on a vertical split' })
km.set('n', '<leader>scs', ':vsp<cr> :args %:p:h/*.css     <cr><cr>', { desc = 'Open .css on a vertical split' })

-- fold
km.set('n', '<c-j>', '<c-w>j<cr>', { desc = 'fold' })
km.set('n', '<c-h>', '<c-w>h<cr>', { desc = 'fold' })
km.set('n', '<c-l>', '<c-w>l<cr>', { desc = 'fold' })
km.set('n', '<c-k>', '<c-w>k<cr>', { desc = 'fold' })

-- Use left/right to indent
km.set('n', '<left>', '<<', { desc = 'Use left/right to indent' })
km.set('n', '<right>', '>>', { desc = 'Use left/right to indent' })
km.set('v', '<left>', '<gv', { desc = 'Use left/right to indent' })
km.set('v', '<right>', '>gv', { desc = 'Use left/right to indent' })

--  Use up/down to move lines/blocks
km.set('n', '<up>  ', ':m -2<cr>', { desc = 'Use up/down to move lines/blocks' })
km.set('n', '<down>', ':m +1<cr>', { desc = 'Use up/down to move lines/blocks' })
km.set('v', '<up>  ', ':m -2<cr>gv', { desc = 'Use up/down to move lines/blocks' })
km.set('v', '<down>', ":m '>+1<cr>gv", { desc = 'Use up/down to move lines/blocks' })

-- Use shift+arrow keys to resize splits
km.set('n', '<s-up>   ', ':resize -2<cr>', { desc = 'Use shift+arrow keys to resize splits' })
km.set('n', '<s-down> ', ':resize +2<cr>', { desc = 'Use shift+arrow keys to resize splits' })
km.set('n', '<s-right>', ':vertical resize -1<cr>', { desc = 'Use shift+arrow keys to resize splits' })
km.set('n', '<s-left> ', ':vertical resize +2<cr>n', { desc = 'Use shift+arrow keys to resize splits' })
