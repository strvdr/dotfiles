return {

    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,  
    opts = {},
    name = "tokyonight",


    config = function()

        vim.cmd.colorscheme "tokyonight"

    end
}
