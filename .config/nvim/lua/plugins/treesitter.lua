return
  {"nvim-treesitter/nvim-treesitter",
  build=":TSUpdate",

  config=function()

    local config=require("nvim-treesitter.configs")
    config.setup({
      ensure_installed = {"lua", "javascript", "python", "c", "go", "bash", "cpp", "html", "css", "dockerfile", "nginx", "vim", "yaml", "zig"},
      highlight = {enable = true},
      indent={enable=true};

  })

  end

}
