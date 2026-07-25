-- In your vimtex.lua file
return {
  "lervag/vimtex",
  lazy = false,
  config = function()
    -- Basic Vimtex settings
    vim.g.vimtex_view_method = 'general'
    vim.g.vimtex_view_general_viewer = 'evince'
    
    -- Enable automatic compilation on save
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_compiler_latexmk = {
      build_dir = '',
      callback = 1,
      continuous = 1,
      executable = 'latexmk',
      options = {
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
      },
    }
    
    -- Custom keybindings
    vim.keymap.set('n', '<leader>tc', '<cmd>VimtexCompile<CR>', { desc = "Toggle compile mode" })
    vim.keymap.set('n', '<leader>tz', '<cmd>VimtexView<CR>', { desc = "Open PDF in Zathura" })
  end,
}
