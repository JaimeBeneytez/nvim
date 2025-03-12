return {
  'Exafunction/codeium.vim',
  event = 'BufEnter',
  config = function()
    -- Set up key bindings using vim.keymap.set or vim.api.nvim_set_keymap
    vim.keymap.set('i', '<C-;>', function() return vim.fn['codeium#Accept']() end, { expr = true, noremap = true })
    vim.keymap.set('i', '<C-m>', function() return vim.fn end, { expr = true, noremap = true })
    vim.keymap.set('i', '<C-,', function() return vim.fn['codeium#CycleCompletions'](-1) end, { expr = true, noremap = true })
  end,
}
