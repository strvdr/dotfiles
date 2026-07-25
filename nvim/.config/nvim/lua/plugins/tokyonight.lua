return {

    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,  
    opts = {
        style = "night",
        transparent = false,
        terminal_colors = true,
        styles = {
            sidebars = "dark",
            floats = "dark",
        },
    },
    name = "tokyonight",


    config = function()

        vim.cmd.colorscheme "tokyonight-night"

    end
}
